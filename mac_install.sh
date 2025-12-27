#!/bin/bash

set -e

# スクリプトの配置ディレクトリを取得
current_dir=$(cd "$(dirname "$0")" && pwd)

backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

ensure_symlink() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      return 0
    fi
    rm -f "$dest"
  elif [ -f "$dest" ]; then
    rm -f "$dest"
  elif [ -d "$dest" ]; then
    mkdir -p "$backup_dir"
    mv "$dest" "$backup_dir/"
  fi

  ln -s "$src" "$dest"
}

ensure_line_in_file() {
  local line="$1"
  local file="$2"

  if [ -f "$file" ] && grep -Fxq "$line" "$file"; then
    return 0
  fi

  sudo sh -c "echo '$line' >> '$file'"
}

# Homebrew のインストールと設定
# 公式サイト: https://brew.sh/
# Homebrew は macOS 用のパッケージマネージャーで、コマンドラインツールやアプリケーションのインストールを簡単に行えます。
ensure_brew_formula() {
  local pkg="$1"
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    return 0
  fi
  brew install "$pkg"
}

ensure_brew_cask() {
  local pkg="$1"
  if brew list --cask "$pkg" >/dev/null 2>&1; then
    return 0
  fi
  brew install --cask "$pkg"
}

ensure_brew_formula fish
ensure_brew_formula fzf
ensure_brew_formula ghq
ensure_brew_formula git
ensure_brew_formula git-extras
ensure_brew_formula gpg
ensure_brew_formula jq
ensure_brew_formula mise
ensure_brew_formula neovim
ensure_brew_formula nkf
ensure_brew_formula reattach-to-user-namespace
ensure_brew_formula starship
ensure_brew_formula tmux
ensure_brew_formula tree
ensure_brew_formula luarocks

# GUIアプリケーションのインストール
ensure_brew_cask codex
ensure_brew_cask wezterm

# 以下のアプリは手動でインストールする必要があります。App Storeや各公式サイトからダウンロードしてください。
# 例: 1Password, Better Touch Tool, Discord, Notion, Raycast, Spotify, AppCleaner, Bear, Docker for Desktop, Google Chrome, Google Japanese IME, IntelliJ IDEA, Numi, SiteSucker, Slack

# dotfiles の設定
# dotfiles は、開発環境の設定ファイル群です。これらをリンクすることで、新しいマシンでも独自の環境を素早く構築できます。
mkdir -p ~/.config/fish
ensure_symlink "$current_dir/fish/config.fish" ~/.config/fish/config.fish
ensure_symlink "$current_dir/fish/fishfile" ~/.config/fish/fishfile
ensure_symlink "$current_dir/.vimrc" ~/.vimrc
ensure_symlink "$current_dir/.vim" ~/.vim
ensure_symlink "$current_dir/.tmux.conf" ~/.tmux.conf
ensure_symlink "$current_dir/git/.gitconfig" ~/.gitconfig
ensure_symlink "$current_dir/git/.gitignore_global" ~/.gitignore_global
ensure_symlink "$current_dir/.globalrc" ~/.globalrc
ensure_symlink "$current_dir/.wezterm.lua" ~/.wezterm.lua
ensure_symlink "$current_dir/starship.toml" ~/.config/starship.toml
ensure_symlink "$current_dir/starship" ~/.config/starship
ensure_symlink "$current_dir/nvim" ~/.config/nvim

mkdir -p ~/bin
ensure_symlink "$current_dir/git/scripts/new-branch.sh" ~/bin/git-new-branch

# fish シェルをデフォルトに設定
# fish は使いやすさを重視したコマンドラインシェルです。
fish_path="$(command -v fish || true)"
if [ -n "$fish_path" ]; then
  ensure_line_in_file "$fish_path" "/etc/shells"
  if [ "$SHELL" != "$fish_path" ]; then
    chsh -s "$fish_path"
  fi
else
  echo "fish not found in PATH; skipping chsh"
fi

# Fisher のインストール
# Fisher は fish のパッケージマネージャーで、様々なプラグインを簡単にインストールできます。
if [ ! -f ~/.config/fish/functions/fisher.fish ]; then
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fi

# fish のプラグインをインストール
fish -c "contains jethrokuan/z (fisher list); or fisher install jethrokuan/z"
fish -c "contains jethrokuan/fzf (fisher list); or fisher install jethrokuan/fzf"
fish -c "contains decors/fish-ghq (fisher list); or fisher install decors/fish-ghq"
fish -c "contains wfxr/forgit (fisher list); or fisher install wfxr/forgit"

# フォントをインストール
# https://www.nerdfonts.com/font-downloads
