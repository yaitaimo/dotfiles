#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "boto3>=1.34",
#   "InquirerPy>=0.3",
# ]
# ///

from __future__ import annotations

import argparse
import os
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any

import boto3
from InquirerPy import inquirer


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Select an ECS task/container interactively and run ecs execute-command.",
    )
    parser.add_argument("--profile", help="AWS profile name.")
    parser.add_argument("--region", help="AWS region name.")
    parser.add_argument("--cluster", help="ECS cluster ARN or name.")
    parser.add_argument("--task", help="ECS task ARN or ID.")
    parser.add_argument("--container", help="Container name.")
    parser.add_argument("--remote-path", help="Remote file path to fetch with cat.")
    parser.add_argument(
        "--remote-start",
        default="/tmp",
        help="Initial remote directory for interactive path selection.",
    )
    parser.add_argument(
        "--no-remote-browser",
        action="store_true",
        help="Disable interactive remote path browser and use text input.",
    )
    parser.add_argument("--command", help="Command to run instead of cat <remote-path>.")
    parser.add_argument(
        "--output",
        "-o",
        help="Local output file path. Use '-' to stream to stdout.",
    )
    return parser.parse_args()


def page_all(client: Any, operation: str, key: str, **kwargs: Any) -> list[Any]:
    paginator = client.get_paginator(operation)
    items: list[Any] = []
    for page in paginator.paginate(**kwargs):
        items.extend(page.get(key, []))
    return items


def short_arn(value: str) -> str:
    return value.rsplit("/", 1)[-1]


def choose_cluster(ecs: Any, cluster_arg: str | None) -> str:
    if cluster_arg:
        return cluster_arg

    clusters = page_all(ecs, "list_clusters", "clusterArns")
    if not clusters:
        raise RuntimeError("ECS cluster が見つかりませんでした。")

    return inquirer.select(
        message="ECS cluster を選択してください:",
        choices=[{"name": short_arn(arn), "value": arn} for arn in clusters],
        mandatory=True,
    ).execute()


def describe_tasks(ecs: Any, cluster: str, task_arns: list[str]) -> list[dict[str, Any]]:
    tasks: list[dict[str, Any]] = []
    for i in range(0, len(task_arns), 100):
        response = ecs.describe_tasks(cluster=cluster, tasks=task_arns[i : i + 100])
        tasks.extend(response.get("tasks", []))
    return tasks


def choose_task(ecs: Any, cluster: str, task_arg: str | None) -> str:
    if task_arg:
        return task_arg

    task_arns = page_all(
        ecs,
        "list_tasks",
        "taskArns",
        cluster=cluster,
        desiredStatus="RUNNING",
    )
    if not task_arns:
        raise RuntimeError("RUNNING の ECS task が見つかりませんでした。")

    tasks = describe_tasks(ecs, cluster, task_arns)
    choices = []
    for task in tasks:
        task_id = short_arn(task["taskArn"])
        group = task.get("group", "-")
        last_status = task.get("lastStatus", "-")
        containers = ", ".join(c["name"] for c in task.get("containers", []))
        exec_flag = "exec:on" if task.get("enableExecuteCommand") else "exec:off"
        choices.append(
            {
                "name": f"{task_id} | {group} | {last_status} | {exec_flag} | {containers}",
                "value": task["taskArn"],
            }
        )

    return inquirer.fuzzy(
        message="ECS task を選択してください:",
        choices=choices,
        mandatory=True,
        max_height=min(20, max(5, len(choices))),
    ).execute()


def choose_container(
    ecs: Any,
    cluster: str,
    task: str,
    container_arg: str | None,
) -> str:
    if container_arg:
        return container_arg

    tasks = describe_tasks(ecs, cluster, [task])
    if not tasks:
        raise RuntimeError("ECS task の詳細を取得できませんでした。")

    containers = [c["name"] for c in tasks[0].get("containers", [])]
    if not containers:
        raise RuntimeError("ECS task に container が見つかりませんでした。")

    if len(containers) == 1:
        return containers[0]

    return inquirer.select(
        message="Container を選択してください:",
        choices=containers,
        mandatory=True,
    ).execute()


def shell_command(script: str, *script_args: str) -> str:
    command = ["sh", "-lc", script, "sh", *script_args]
    return " ".join(shlex.quote(part) for part in command)


def remote_join(directory: str, name: str) -> str:
    if directory == "/":
        return f"/{name}"
    return f"{directory.rstrip('/')}/{name}"


def parent_dir(directory: str) -> str:
    if directory == "/":
        return "/"
    parent = directory.rstrip("/").rsplit("/", 1)[0]
    return parent or "/"


def list_remote_entries(
    args: argparse.Namespace,
    cluster: str,
    task: str,
    container: str,
    directory: str,
) -> list[dict[str, str]]:
    script = r'''
dir=$1
for p in "$dir"/* "$dir"/.[!.]* "$dir"/..?*; do
  [ -e "$p" ] || continue
  name=${p##*/}
  if [ -d "$p" ]; then
    printf 'd\t%s\n' "$name"
  elif [ -f "$p" ]; then
    printf 'f\t%s\n' "$name"
  else
    printf 'o\t%s\n' "$name"
  fi
done
'''
    cli = build_aws_cli(
        args,
        cluster,
        task,
        container,
        shell_command(script, directory),
    )
    result = subprocess.run(cli, capture_output=True, text=True)
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(f"remote directory を取得できませんでした: {detail}")

    entries = []
    for line in result.stdout.splitlines():
        kind, separator, name = line.partition("\t")
        if separator and kind in {"d", "f", "o"} and name not in {".", ".."}:
            entries.append({"kind": kind, "name": name})
    entries.sort(key=lambda item: (item["kind"] != "d", item["name"]))
    return entries


def browse_remote_path(
    args: argparse.Namespace,
    cluster: str,
    task: str,
    container: str,
) -> str:
    current_dir = args.remote_start

    while True:
        entries = list_remote_entries(args, cluster, task, container, current_dir)
        choices: list[dict[str, Any]] = [
            {"name": "[manual] path を手入力", "value": {"action": "manual"}},
        ]
        if current_dir != "/":
            choices.append(
                {
                    "name": f"[dir] .. -> {parent_dir(current_dir)}",
                    "value": {"action": "cd", "path": parent_dir(current_dir)},
                }
            )

        for entry in entries:
            path = remote_join(current_dir, entry["name"])
            if entry["kind"] == "d":
                choices.append(
                    {
                        "name": f"[dir]  {entry['name']}/",
                        "value": {"action": "cd", "path": path},
                    }
                )
            elif entry["kind"] == "f":
                choices.append(
                    {
                        "name": f"[file] {entry['name']}",
                        "value": {"action": "file", "path": path},
                    }
                )
            else:
                choices.append(
                    {
                        "name": f"[other] {entry['name']}",
                        "value": {"action": "file", "path": path},
                    }
                )

        selected = inquirer.fuzzy(
            message=f"取得する remote file path: {current_dir}",
            choices=choices,
            mandatory=True,
            max_height=20,
        ).execute()

        if selected["action"] == "manual":
            return inquirer.text(
                message="取得する remote file path:",
                default=current_dir,
                mandatory=True,
            ).execute()
        if selected["action"] == "cd":
            current_dir = selected["path"]
            continue
        return selected["path"]


def resolve_command(
    args: argparse.Namespace,
    cluster: str,
    task: str,
    container: str,
) -> str:
    if args.command:
        return args.command

    if args.remote_path:
        remote_path = args.remote_path
    elif args.no_remote_browser:
        remote_path = inquirer.text(
            message="取得する remote file path:",
            default="/tmp/old.csv",
            mandatory=True,
        ).execute()
    else:
        remote_path = browse_remote_path(args, cluster, task, container)
    args.remote_path = remote_path
    return f"cat {shlex.quote(remote_path)}"


def resolve_output(args: argparse.Namespace) -> Path | None:
    if args.output == "-":
        return None

    default_name = "ecs-command-output.txt"
    if args.remote_path:
        default_name = Path(args.remote_path).name or default_name

    output = args.output or inquirer.filepath(
        message="保存先 local file path:",
        default=f"~/{default_name}",
        instruction="Tab で補完",
        multicolumn_complete=True,
        mandatory=True,
    ).execute()

    path = Path(output).expanduser()
    if path.exists():
        overwrite = inquirer.confirm(
            message=f"{path} は既に存在します。上書きしますか?",
            default=False,
        ).execute()
        if not overwrite:
            raise RuntimeError("上書きがキャンセルされました。")
    return path


def build_aws_cli(
    args: argparse.Namespace,
    cluster: str,
    task: str,
    container: str,
    command: str,
) -> list[str]:
    cli = ["aws"]
    if args.profile:
        cli.extend(["--profile", args.profile])
    if args.region:
        cli.extend(["--region", args.region])
    cli.extend(
        [
            "ecs",
            "execute-command",
            "--cluster",
            cluster,
            "--task",
            task,
            "--container",
            container,
            "--interactive",
            "--command",
            command,
        ]
    )
    return cli


def main() -> int:
    args = parse_args()

    session = boto3.Session(profile_name=args.profile, region_name=args.region)
    ecs = session.client("ecs")

    cluster = choose_cluster(ecs, args.cluster)
    task = choose_task(ecs, cluster, args.task)
    container = choose_container(ecs, cluster, task, args.container)
    command = resolve_command(args, cluster, task, container)
    output_path = resolve_output(args)
    cli = build_aws_cli(args, cluster, task, container, command)

    print(
        f"execute-command: cluster={short_arn(cluster)} task={short_arn(task)} "
        f"container={container} command={command!r}",
        file=sys.stderr,
    )

    env = os.environ.copy()
    if output_path is None:
        return subprocess.run(cli, env=env).returncode

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("wb") as output:
        result = subprocess.run(cli, stdout=output, env=env)

    if result.returncode == 0:
        print(f"saved: {output_path}", file=sys.stderr)
    return result.returncode


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        print("\nキャンセルしました。", file=sys.stderr)
        raise SystemExit(130)
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        raise SystemExit(1)
