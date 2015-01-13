# xcode-select --install
 
# ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
 
# brew doctor

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Homebrew & Homebrew-Cask
brew update
brew upgrade

brew install caskroom/cask/brew-cask

brew brew-any-tap
brew install python
brew install python3
brew install zsh
brew install lua
brew install vim --devel --with-lua
brew install w3m
brew install git
brew install git-extras
brew install sqlite
brew install termshare
brew install wget
brew install heroku-toolbelt
brew install sl
brew install reattach-to-user-namespace
brew install nkf
brew install tmux
brew install mysql
brew install ctags
brew install hub
brew install fontforge

brew cask install alfred
brew cask install appcleaner
brew cask install bettertouchtool
brew cask install dropbox
brew cask install evernote
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install gyazo
brew cask install karabiner
brew cask install iterm2
brew cask install minecraft
brew cask install macwinzipper
brew cask install openoffice
brew cask install 1password
brew cask install plain-clip
brew cask install xquartz
# brew cask install pycharm
brew cask install sitesucker
brew cask install skype
brew cask install slack
brew cask install torbrowser
brew cask install tunnelblick
brew cask install virtualbox
brew cask install vagrant
brew cask install xquartz

brew cleanup
brew cask cleanup

brew cask alfred link

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

# pip install git+git://github.com/Lokaltog/powerline
# pip install psutil

# pip install markdown

# vim swap & backup directory
mkdir ~/tmp
