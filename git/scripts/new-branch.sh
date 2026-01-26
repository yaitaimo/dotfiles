#!/usr/bin/env bash

# new-branch.sh <new-branch-name>

set -e

if [ $# -eq 0 ]; then
  echo "使い方: new-branch <新しいブランチ名>"
  exit 1
fi

NEW_BRANCH="$1"

# ステージ済・未ステージ変更をstash
echo "🔒 ステージ済・未ステージ変更をstash中..."
git stash push -u -m "auto-stash-for-new-branch"

# ベースブランチに移動し、最新化
resolve_self_dir() {
  local src="$0"
  while [ -h "$src" ]; do
    local dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    [[ $src != /* ]] && src="$dir/$src"
  done
  cd -P "$(dirname "$src")" && pwd
}

SCRIPT_DIR="$(resolve_self_dir)"
"${SCRIPT_DIR}/switch-to-base.sh"

# 新しいブランチ作成
git checkout -b "$NEW_BRANCH"
echo "🌱 新しいブランチ '$NEW_BRANCH' を作成しました"

# stash を戻す
if git stash list | grep -q "auto-stash-for-new-branch"; then
  echo "📦 stash を戻しています..."
  git stash pop
fi
