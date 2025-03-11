#!/bin/bash

set -e

# 現在のディレクトリを取得して変数に格納
current_dir=$(pwd)

# Homebrew のインストールと設定
# 公式サイト: https://brew.sh/
# Homebrew は macOS 用のパッケージマネージャーで、コマンドラインツールやアプリケーションのインストールを簡単に行えます。
brew install \
  fish \
  fzf \
  ghq \
  git \
  git-extras \
  jq \
  neovim \
  nkf \
  reattach-to-user-namespace \
  starship \
  tmux \
  tree \
  luarocks

# GUIアプリケーションのインストール
brew install \
  wezterm

# 以下のアプリは手動でインストールする必要があります。App Storeや各公式サイトからダウンロードしてください。
# 例: 1Password, Better Touch Tool, Discord, Notion, Raycast, Spotify, AppCleaner, Bear, Docker for Desktop, Google Chrome, Google Japanese IME, IntelliJ IDEA, Numi, SiteSucker, Slack

# dotfiles の設定
# dotfiles は、開発環境の設定ファイル群です。これらをリンクすることで、新しいマシンでも独自の環境を素早く構築できます。
mkdir -p ~/.config/fish
ln -sf "$current_dir/fish/config.fish" ~/.config/fish/config.fish
ln -sf "$current_dir/fish/fishfile" ~/.config/fish/fishfile
ln -sf "$current_dir/.vimrc" ~/
ln -sf "$current_dir/.vim" ~/
ln -sf "$current_dir/.tmux.conf" ~/
ln -sf "$current_dir/.gitconfig" ~/
ln -sf "$current_dir/.gitignore_global" ~/.gitignore_global
ln -sf "$current_dir/.globalrc" ~/
ln -sf "$current_dir/.wezterm.lua" ~/

# NeoVim の設定
# NeoVim は Vim の改良版で、拡張性とカスタマイズ性に優れたテキストエディタです。
mkdir -p ~/.config/nvim
ln -sf "$current_dir/.vimrc" ~/.config/nvim/init.vim

# fish シェルをデフォルトに設定
# fish は使いやすさを重視したコマンドラインシェルです。
sudo sh -c "echo '/opt/homebrew/bin/fish' >> /etc/shells"
chsh -s /opt/homebrew/bin/fish

# Fisher のインストール
# Fisher は fish のパッケージマネージャーで、様々なプラグインを簡単にインストールできます。
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c fisher

# fish のプラグインをインストール
fisher add jethrokuan/z
fisher add jethrokuan/fzf
fisher add decors/fish-ghq

# フォントをインストール
# https://www.nerdfonts.com/font-downloads
bash bin/install_font.sh
