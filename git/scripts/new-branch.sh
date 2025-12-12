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

# ベースブランチ候補の探索（リモート優先）
BASE_BRANCH=""

# origin のデフォルトブランチ (GitHub 側) を取得
BASE_BRANCH="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')"

# init.defaultBranch が設定されていれば使用
if [ -z "$BASE_BRANCH" ]; then
  BASE_BRANCH="$(git config --get init.defaultBranch || true)"
fi

# それでも決まらなければローカルの候補順に探索
if [ -z "$BASE_BRANCH" ]; then
  for b in develop master main; do
    if git show-ref --verify --quiet refs/heads/"$b"; then
      BASE_BRANCH="$b"
      break
    fi
  done
fi

if [ -z "$BASE_BRANCH" ]; then
  echo "⚠️ develop / master / main のいずれのブランチも見つかりませんでした。"
  exit 1
fi

echo "🧭 ベースブランチとして '$BASE_BRANCH' を使用します"

# ベースブランチに移動し、最新化
git fetch origin "$BASE_BRANCH"
git checkout "$BASE_BRANCH"
git pull --rebase origin "$BASE_BRANCH"

# 新しいブランチ作成
git checkout -b "$NEW_BRANCH"
echo "🌱 新しいブランチ '$NEW_BRANCH' を作成しました"

# stash を戻す
if git stash list | grep -q "auto-stash-for-new-branch"; then
  echo "📦 stash を戻しています..."
  git stash pop
fi
