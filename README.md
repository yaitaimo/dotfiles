# yaitaimo's dotfiles

macOS 向けの個人用セットアップ。Homebrew でツールを入れ、シンボリックリンクで設定を張ります。

## セットアップ
1. Xcode Command Line Tools を入れていない場合は `xcode-select --install` を実行。
2. リポジトリを取得して実行:
   ```bash
   git clone https://github.com/yaitaimo/dotfiles.git
   cd dotfiles
   ./mac_install.sh
   ```
3. 主な処理内容:
- Homebrew で CLI/GUI ツールを導入
- fish をログインシェルに設定（`/etc/shells` 追記と `chsh`）
- dotfiles を `~/.config` などへ symlink
- Fisher と fish プラグインを導入

## ディレクトリ構成
- `fish/`: Fish 設定・補完・関数（`config.fish`, `functions/*.fish`）。
- `nvim/`: Neovim 設定（`lazy.nvim` + `lua/plugins/*.lua`）。
- `git/`: Git 設定と補助スクリプト（`git/scripts/new-branch.sh` など）。
- `bin/`: `~/bin` 向けユーティリティ。
- `starship/`: Starship 設定。
- `mac_install.sh`: macOS 初期セットアップスクリプト。

## 主な設定内容
- Shell (`fish/config.fish`)
- エイリアス例: `g`, `gp`, `v`, `lg`, `we`
- `FZF_DEFAULT_COMMAND` は `ag -g ""`
- ローカル上書きは `~/.config/fish/local.fish`

- Neovim (`nvim/`)
- リーダーキーは `;`
- 検索: Telescope（`<leader>p`, `<leader>lg`, `<leader>fb`）
- Git: Fugitive（`<leader>b`）、Gitsigns、Diffview（`<leader>gd` など）
- ターミナル: ToggleTerm（`<leader>tt`, `<leader>tc`）、Lazygit（`<leader>g`）
- AI: codex.nvim（`<leader>j`）。ToggleTerm 経由の起動設定もあり（`<leader>atc`, `<leader>atg`）
- 保存時処理: 全ファイルの末尾空白を削除
- LSP・formatter のプラグイン設定は未導入

- Terminal / Multiplexer
- tmux: プレフィックス `Ctrl-t`
- tmux/SSH: copy-mode の `y` / `Enter` / mouse copy は OSC 52 で手元の clipboard へ転送
- WezTerm: Solarized 自動切替、`RobotoMono Nerd Font`、リーダーキー `Cmd-;`

## 日常運用コマンド
- `fish -n fish/config.fish`: Fish 設定の構文チェック
- `bash -n mac_install.sh`: セットアップスクリプトの構文チェック
- `nvim`: リンク済み Neovim 設定で起動
- `~/bin/git-new-branch <branch-name>`: 作業ブランチ作成補助
- `ecs-fetch-file`: ECS task/container を選択し、`execute-command` でファイル内容を取得

## 注意事項
- `mac_install.sh` はシェル変更（`chsh`）と `sudo` を伴うため、実行前に内容を確認してください。
- フォントは Nerd Fonts の `RobotoMono Nerd Font` を別途インストールしてください。
- マシン固有設定は `~/.config/fish/local.fish` に置き、リポジトリには含めない運用を推奨します。

## エージェント運用
エージェント向けルールは `AGENTS.md` を参照してください。`worktree` 運用、`codex/<task-id>` ブランチ方針、グローバル設定変更時の報告要件を定義しています。

## Neovim 設定の拡張

- `nvim/init.lua`: 基本設定 → lazy.nvim → 標準キーマップ → autocmd の読み込み順。
- `nvim/lua/config/`: 基本設定、標準キーマップ、autocmd、lazy.nvim の bootstrap。
- `nvim/lua/plugins/`: 機能別のプラグイン spec。ファイルを追加すると lazy.nvim が読み込む。
  - `ui.lua`: 配色・ステータスライン・キーガイド。
  - `editor.lua`: コメント操作。
  - `telescope.lua`, `git.lua`, `terminal.lua`, `ai.lua`: 各機能の設定。
  - ToggleTerm 経由の Lazygit・AI 起動は `terminal.lua` が管理する。
- `nvim/lua/util/project.lua`: Git ルート取得。取得失敗時は作業ディレクトリを使う。

プラグイン固有のキーは各 spec の `keys` に、設定値は `opts` に置き、
追加の初期化が必要な場合だけ `config` を使う。プラグインを必要としないキーは
`config/keymaps.lua` に置く。`keys` や `cmd` の追加は遅延読み込みに影響するため、
起動時の読み込みが必要な場合は `lazy = false` を明示する。
autocmd は名前付き augroup に登録し、再登録時の重複を防ぐ。

LSP・formatter は導入時に spec を追加する。プラグイン更新は構成変更と分けて行い、
`lazy-lock.json` の変更内容を確認する。設定変更の反映は Neovim の再起動で確認する。
既存の `.r` は残しているが、モジュールの再読み込みには対応していない。
