# yaitaimo's dotfiles

macOS 向けの個人用セットアップ。Homebrew でツールを入れ、シンボリックリンクで設定を張ります。

## セットアップ手順
1. Xcode Command Line Tools を入れていない場合は `xcode-select --install` を実行。
2. リポジトリを取得してスクリプトを実行:
   ```bash
   git clone https://github.com/yaitaimo/dotfiles.git
   cd dotfiles
   ./mac_install.sh
   ```
   - Homebrew で CLI/GUI ツールをインストール
   - fish をログインシェルに設定（sudo で /etc/shells 追記と `chsh`）
   - dotfiles を `~/.config` などへ symlink
   - Fisher と fish プラグインを導入

## 含まれる主な設定
- Shell: `fish/config.fish`, `starship/starship.toml`
  - alias: `g`=git, `v`=nvim, `lg`=lazygit ほか
  - fzf デフォルトコマンドに `ag` を使用
  - Fisher プラグイン: `jethrokuan/z`, `jethrokuan/fzf`, `decors/fish-ghq`, `wfxr/forgit`
- Neovim: `nvim/`
  - `lazy.nvim` 管理、リーダーキー `;`
  - UI: solarized カラースキーム、lualine
  - LSP: mason + nvim-lspconfig（lua/ts/python/go など）。`gd`, `gr`, `K`, `<leader>rn`, `<leader>f` などを割当
  - フォーマット: conform.nvim が保存時に prettier/black/goimports 等を実行
  - 検索: Telescope（`<leader>p` git ルートのファイルブラウザ、`<leader>lg` live grep、`<leader>b` バッファなど）
  - 構文: Treesitter で主要言語をインストール
  - Git: diffview.nvim を `<leader>gd` などで起動
  - ターミナル: toggleterm（フロート端末、`<Leader>g` で lazygit、Codex/Copilot 用トグルあり）
  - AI: Copilot 本体と CopilotChat を同梱（必要に応じてトークン設定）
- tmux: `.tmux.conf`
  - プレフィックス `Ctrl-t`、`Ctrl-S`/`Ctrl-V` で分割、`Ctrl-R` で再読み込み。マウス有効、クリップボード連携
- WezTerm: `.wezterm.lua`
  - macOS のライト/ダークに合わせて Solarized 配色を自動切替
  - フォントは `RobotoMono Nerd Font`（日本語 fallback あり）、リーダー `Ctrl-t`、`Cmd+Ctrl+f` でフルスクリーン
- Git ヘルパー
  - `git/scripts/new-branch.sh`: 変更を stash してベースブランチを最新化後、新規ブランチを作成し stash を戻す

## メモ
- フォントは Nerd Fonts から `RobotoMono Nerd Font` を別途インストールしてください。
- `mac_install.sh` の GUI アプリ（1Password, Raycast など）は手動インストールです。
