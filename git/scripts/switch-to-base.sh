#!/usr/bin/env bash

# ベースブランチを特定し、最新化してチェックアウトする

set -euo pipefail

find_base_branch() {
  local base_branch=""

  # origin のデフォルトブランチ (GitHub 側) を取得
  base_branch="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')"

  # init.defaultBranch が設定されていれば使用
  if [ -z "$base_branch" ]; then
    base_branch="$(git config --get init.defaultBranch || true)"
  fi

  # それでも決まらなければローカルの候補順に探索
  if [ -z "$base_branch" ]; then
    for b in develop master main; do
      if git show-ref --verify --quiet refs/heads/"$b"; then
        base_branch="$b"
        break
      fi
    done
  fi

  echo "$base_branch"
}

switch_to_base_branch() {
  BASE_BRANCH="$(find_base_branch)"

  if [ -z "${BASE_BRANCH:-}" ]; then
    echo "⚠️ develop / master / main のいずれのブランチも見つかりませんでした。"
    exit 1
  fi

  echo "🧭 ベースブランチとして '$BASE_BRANCH' を使用します"

  git fetch origin "$BASE_BRANCH"
  git checkout "$BASE_BRANCH"
  git pull --rebase origin "$BASE_BRANCH"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  switch_to_base_branch
fi
