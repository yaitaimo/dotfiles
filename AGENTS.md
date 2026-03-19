# AGENTS Guide

このファイルは、Codex などのエージェントがこのリポジトリで作業する際の最小運用ルールです。

## 利用言語
- 作業報告・PR 説明・コメントは日本語で簡潔かつ丁寧に記述する。

## グローバル設定変更の共有
- 端末やツールのグローバル設定を変更した場合は、作業報告で必ず明示する。
- 対象例: `mise use -g`, `git config --global`, `aws configure`, `gh auth login`。
- 共有の最小セット:
  - 変更内容（何をどう変更したか）
  - 反映先ファイル/場所（例: `~/.config/mise/config.toml`）
  - 必要なら戻し方

## Git 運用
- Git 管理下の作業は、原則として開始時に専用 `worktree` を作成する。
- ブランチは必ず新規作成し、`codex/<task-id>` 形式を使う。
- `main` / `develop` など共有ブランチへ直接コミットしない。
- 既存の未コミット変更は勝手に破棄しない。

## リポジトリ構成
- `fish/`: Fish 設定・補完・関数。
- `nvim/`: Neovim 設定（`nvim/lua/` に Lua モジュール）。
- `git/`: Git 設定と補助スクリプト。
- `bin/`: `~/bin` にリンクするユーティリティ。
- `starship/`: Starship 設定。
- `mac_install.sh`: macOS 初期セットアップとシンボリックリンク作成。

## 変更時の方針
- 既存スタイルを維持する（Fish は `set`/`alias`、Lua はモジュール分割）。
- Neovim の Lua 編集は `expandtab` / `shiftwidth=2` / `tabstop=4` に合わせる。
- マシン固有値は `~/.config/fish/local.fish` へ分離し、リポジトリへ直書きしない。

## 動作確認
- 自動テストはないため、変更箇所に応じて最小限の検証を行う。
- 例: `fish -n fish/config.fish`, `bash -n mac_install.sh`。

## コミット/PR
- コミットメッセージは日本語の短い説明を基本にする。
- PR には「変更要約」と「手動確認結果」を含める。
