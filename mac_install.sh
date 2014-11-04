# xcode-select --install
 
# ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
 
# brew doctor

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Homebrew & Homebrew-Cask
brew update
brew upgrade

brew install caskroom/cask/brew-cask

brew install python
brew install python3
brew install zsh
brew install lua
brew install vim --devel --with-lua
brew install w3m
brew install git
brew install wget
brew install heroku-toolbelt
brew install sl
brew install reattach-to-user-namespace
brew install nkf
brew install mysql
brew install ctags
brew install hub

brew cask install alfred
brew cask install appcleaner
brew cask install bettertouchtool
brew cask install dropbox
brew cask install evernote
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install gyazo
brew cask install iterm2
brew cask install minecraft
brew cask install macwinzipper
brew cask install openoffice
brew cask install onepassword
brew cask install sitesucker
brew cask install skype
brew cask install slack
brew cask install torbrowser
brew cask install virtualbox
brew cask install vagrant

brew cleanup
brew cask cleanup

brew cask alfred link

# LINE
# brew opencv
# PlainCalc
