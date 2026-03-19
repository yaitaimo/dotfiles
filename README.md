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
- `nvim/`: Neovim 設定（`lazy.nvim` + `lua/plugins_specs/*.lua`）。
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
- LSP: mason + nvim-lspconfig（Lua/Python/TS/Go など）
- フォーマット: conform.nvim（保存時）
- 検索: Telescope（`<leader>p`, `<leader>lg`, `<leader>b`）
- Git: diffview.nvim（`<leader>gd` など）
- AI: Copilot / CopilotChat / codex.nvim

- Terminal / Multiplexer
- tmux: プレフィックス `Ctrl-t`
- WezTerm: Solarized 自動切替、`RobotoMono Nerd Font`

## 日常運用コマンド
- `fish -n fish/config.fish`: Fish 設定の構文チェック
- `bash -n mac_install.sh`: セットアップスクリプトの構文チェック
- `nvim`: リンク済み Neovim 設定で起動
- `~/bin/git-new-branch <branch-name>`: 作業ブランチ作成補助

## 注意事項
- `mac_install.sh` はシェル変更（`chsh`）と `sudo` を伴うため、実行前に内容を確認してください。
- フォントは Nerd Fonts の `RobotoMono Nerd Font` を別途インストールしてください。
- マシン固有設定は `~/.config/fish/local.fish` に置き、リポジトリには含めない運用を推奨します。

## エージェント運用
エージェント向けルールは `AGENTS.md` を参照してください。`worktree` 運用、`codex/<task-id>` ブランチ方針、グローバル設定変更時の報告要件を定義しています。
