# xcode-select --install
 
# Homebrew

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 
brew install autojump
brew install ctags
brew install direnv
brew install fontforge
brew install git
brew install git-extras
brew install gnuplot --with-x11
brew install heroku
brew install hub
brew install jq
brew install lha
brew install lua
brew install mysql
brew install neovim/neovim/neovim
brew install nkf
brew insatll peco
brew install python
brew install python3
brew install reattach-to-user-namespace
brew install ruby
brew install sl
brew install source-highlight
brew install sqlite
brew install termshare
brew install tmux
brew install tree
brew install vim --with-lua
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
ln -s ~/dotfiles/.zshrc ~/
ln -s ~/dotfiles/config.fish ~/.config/fish/
ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.gitconfig ~/
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global

# sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
# chsh -s /usr/local/bin/zsh
# echo "export PATH=/usr/local/bin:$PATH" > ~/.zshrc.local

sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
chsh -s /usr/local/bin/fish

fish

curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
fisher z
fisher fzf

# pip install powerline-status
# pip install psutil

# pip install markdown
# pip install ipython
# pip install flake8
