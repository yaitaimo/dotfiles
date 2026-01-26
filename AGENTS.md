# Repository Guidelines

## プロジェクト構成とモジュール整理
このリポジトリは、個人用の dotfiles とセットアップ用スクリプトを管理します。
- `fish/` は Fish の設定・補完・関数を配置します。
- `nvim/` は Neovim 設定を配置します（Lua は `nvim/lua/`）。
- `git/` は Git 設定と補助スクリプトを配置します（例: `git/scripts/new-branch.sh`）。
- `bin/` は `~/bin` 向けの小さなユーティリティを配置します。
- `starship/` と `starship.toml` は Starship の設定です。
- `mac_install.sh` は macOS の初期セットアップとシンボリックリンク作成を行います。

## ビルド・テスト・開発コマンド
- `bash mac_install.sh` は Homebrew パッケージを導入し、設定ファイルをリンクします。
- `fish -c fisher` は `fisher` 導入後に Fish プラグインを入れます。
- `nvim` は `~/.config/nvim` にリンク済みの設定で起動します。

## コーディングスタイルと命名規則
- 既存の言語慣習に合わせます。Fish は `set`/`alias` のパターン、Lua は `nvim/lua/` にモジュール分割します。
- Neovim 設定は `expandtab`、`shiftwidth=2`、`tabstop=4` なので、Lua の編集はこの方針に揃えます。
- スクリプト名は用途が分かる小文字名を推奨します（例: `git-sweep.fish`）。

## テスト方針
- 自動テストはありません。
- スクリプト変更時は簡易確認を行います（例: `fish -n fish/config.fish` で構文チェック、または一度実行）。

## コミットとプルリクエスト
- 既存履歴は日本語の短い説明文が中心です。相似の文体に揃えてください（例: “config.fishでgit pullのエイリアスを追加”）。
- PR には変更内容の要約と手動確認の結果を記載します。UI 設定が変わる場合のみスクリーンショットを添えます。

## セキュリティと設定の注意
- マシン固有の設定は `~/.config/fish/local.fish` に置きます（`fish/config.fish` から読み込み）。
- `mac_install.sh` はパッケージ導入とシェル変更を行うため、実行前に内容を確認してください。
