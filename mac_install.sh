# xcode-select --install
 
# Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 
brew install direnv
brew install fish
brew install fzf
brew install ghq
brew install git
brew install git-extras
brew install global
brew install jq
brew install lha
brew install lua
brew install neovim
brew install nodenv
brew install nkf
brew insatll peco
brew install pyenv
brew install python
brew install python3
brew install reattach-to-user-namespace
brew install rbenv
brew install ruby
brew install sl
brew install sqlite
brew install tmux
brew install tree
brew install vim

brew cleanup

# GUI Application

# 1password
# alfred
# appcleaner
# bear
# bettertouchtool
# docker
# dropbox
# firefox
# google-chrome
# google-japanese-ime
# intellij-idea
# iterm2
# karabiner
# line
# macwinzipper
# messenger(facebook)
# numi
# sitesucker
# skype
# slack
# torbrowser
# tunnelblick
# vagrant
# virtual-box
# wireshark
# xquartz
# yoink

# Dotfiles

# ln -s ~/dotfiles/.zshrc ~/
mkdir -p ~/.config/fish
ln -s ~/dotfiles/fish/config.fish ~/.config/fish/
ln -s ~/dotfiles/fish/fishfilea ~/.config/fish/
ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.gitconfig ~/
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/dotfiles/.globalrc ~/

mkdir ~/.config/nvim
ln -s ~/dotfiles/.vimrc ~/.config/nvim/init.vim

sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
chsh -s /usr/local/bin/fish

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

fish -c fisher

# fisher add jethrokuan/z
# fisher add jethrokuan/fzf
# fisher add decors/fish-ghq
# fisher add kennethreitz/fish-pipenv

# pip3 install powerline-status
# pip3 install psutil

# pip3 install markdown
# pip3 install ipython
# pip3 install flake8
# pip3 install neovim
