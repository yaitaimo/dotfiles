# xcode-select --install
 
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 
# brew doctor

# Homebrew
brew update
brew upgrade

brew brew-any-tap
brew install autojump
brew install ctags
brew install fontforge
brew install git
brew install git-extras
brew install gnuplot --with-x11
brew install heroku-toolbelt
brew install hub
brew install jq
brew install lha
brew install lua
brew install mysql
brew install nkf
brew install python
brew install python3
brew install reattach-to-user-namespace
brew install sl
brew install sqlite
brew install termshare
brew install tmux
brew install tree
brew install vim --with-lua
brew install w3m
brew install wget
brew install zsh
brew install weechat --with-python --with-perl --with-ruby

# 1password
# alfred
# appcleaner
# bettertouchtool
# dropbox
# evernote
# google-chrome
# google-japanese-ime
# gyazo
# iterm2
# karabiner
# macwinzipper
# minecraft
# openoffice
# plain-clip
# sitesucker
# skype
# slack
# torbrowser
# tunnelblick
# vagrant
# virtualbox
# xquartz

brew cleanup

# LINE
# brew opencv
# PlainCalc

# dotfiles
ln -s ~/dotfiles/.zshrc ~/
ln -s ~/dotfiles/.vimrc ~/
ln -s ~/dotfiles/.vim ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.gitconfig ~/

git submodule update --init --recursive

sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

echo "export PATH=/usr/local/bin:$PATH" > ~/.zshrc.local

# pip install powerline-status
# pip install psutil

# pip install markdown
# pip install ipython

# vim swap & backup directory

# Geeknote http://www.geeknote.me/install/
mkdir ~/tmp
