# xcode-select --install
 
# Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 
brew install ag
brew install autojump
brew install ctags
brew install direnv
brew install fish
brew install fontforge
brew install fzf
brew install ghq
brew install git
brew install git-extras
brew install global --with-ctags --with-pygments
brew install gnuplot --with-x11
brew install heroku
brew install hub
brew install jq
brew install lha
brew install lua
brew install mysql
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
brew install source-highlight
brew install sqlite
brew install termshare
brew install tmux
brew install tree
brew install vim --with-python3 --with-lua
brew install w3m
brew install wget
brew install zsh

brew cleanup

# 1password
# alfred
# appcleaner
# bettertouchtool
# docker
# dropbox
# evernote
# google-chrome
# google-drive
# google-japanese-ime
# gyazo
# iterm2
# karabiner
# macwinzipper
# messenger
# minecraft
# openoffice
# plain-clip
# plaincalc
# sitesucker
# skype
# slack
# torbrowser
# tunnelblick
# vagrant
# virtualbox
# xquartz

# LINE
# brew opencv
# PlainCalc

# dotfiles
# ln -s ~/dotfiles/.zshrc ~/
mkdir -p ~/.config/fish
ln -s ~/dotfiles/config.fish ~/.config/fish/
ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.gitconfig ~/
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
ln -s ~/dotfiles/.globalrc ~/

mkdir ~/.config/nvim
ln -s ~/dotfiles/.vimrc ~/.config/nvim/init.vim

# sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
# chsh -s /usr/local/bin/zsh
# echo "export PATH=/usr/local/bin:$PATH" > ~/.zshrc.local

sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
chsh -s /usr/local/bin/fish

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

fish

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
