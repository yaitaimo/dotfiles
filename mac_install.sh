#!/bin/bash

set -e

# スクリプトの配置ディレクトリを取得
current_dir=$(cd "$(dirname "$0")" && pwd)

backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

ensure_symlink() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

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

# Homebrew 自体はこのスクリプトではインストールせず、事前導入を前提にします。
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew が見つかりません。先に https://brew.sh/ からインストールしてください。"
  exit 1
fi

brew_formulas=(
  fish
  fzf
  gh
  ghq
  git
  git-extras
  gpg
  jq
  luarocks
  mise
  neovim
  nkf
  reattach-to-user-namespace
  starship
  tmux
  tree
)

brew_casks=(
  codex
  wezterm@nightly
)

for formula in "${brew_formulas[@]}"; do
  ensure_brew_formula "$formula"
done

# GUIアプリケーションのインストール
for cask in "${brew_casks[@]}"; do
  ensure_brew_cask "$cask"
done

# 以下のアプリは手動でインストールする必要があります。App Storeや各公式サイトからダウンロードしてください。
# 例: 1Password, Better Touch Tool, Discord, Notion, Raycast, Spotify, AppCleaner, Bear, Docker for Desktop, Google Chrome, Google Japanese IME, IntelliJ IDEA, Numi, SiteSucker, Slack

# dotfiles の設定
# dotfiles は、開発環境の設定ファイル群です。これらをリンクすることで、新しいマシンでも独自の環境を素早く構築できます。
symlink_pairs=(
  "$current_dir/fish/config.fish:$HOME/.config/fish/config.fish"
  "$current_dir/fish/fishfile:$HOME/.config/fish/fishfile"
  "$current_dir/fish/conf.d:$HOME/.config/fish/conf.d"
  "$current_dir/fish/functions:$HOME/.config/fish/functions"
  "$current_dir/fish/completions:$HOME/.config/fish/completions"
  "$current_dir/.vimrc:$HOME/.vimrc"
  "$current_dir/.vim:$HOME/.vim"
  "$current_dir/.tmux.conf:$HOME/.tmux.conf"
  "$current_dir/git/.gitconfig:$HOME/.gitconfig"
  "$current_dir/git/.gitignore_global:$HOME/.gitignore_global"
  "$current_dir/.globalrc:$HOME/.globalrc"
  "$current_dir/.wezterm.lua:$HOME/.wezterm.lua"
  "$current_dir/starship/starship.toml:$HOME/.config/starship.toml"
  "$current_dir/starship:$HOME/.config/starship"
  "$current_dir/lazygit/config.yml:$HOME/.config/lazygit/config.yml"
  "$current_dir/nvim:$HOME/.config/nvim"
  "$current_dir/bin/install_font.sh:$HOME/bin/install_font.sh"
  "$current_dir/bin/loadaverage:$HOME/bin/loadaverage"
  "$current_dir/bin/used-mem:$HOME/bin/used-mem"
  "$current_dir/git/scripts/new-branch.sh:$HOME/bin/git-new-branch"
  "$current_dir/git/scripts/switch-to-base.sh:$HOME/bin/git-switch-to-base"
)

for pair in "${symlink_pairs[@]}"; do
  src="${pair%%:*}"
  dest="${pair#*:}"
  ensure_symlink "$src" "$dest"
done

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
