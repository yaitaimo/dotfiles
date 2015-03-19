# xcode-select --install
 
# ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
 
# brew doctor

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Homebrew & Homebrew-Cask
brew update
brew upgrade

brew install caskroom/cask/brew-cask

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

# brew cask install pycharm
brew cask install 1password
brew cask install alfred
brew cask install appcleaner
brew cask install bettertouchtool
brew cask install dropbox
brew cask install evernote
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install gyazo
brew cask install iterm2
brew cask install karabiner
brew cask install macwinzipper
brew cask install minecraft
brew cask install openoffice
brew cask install plain-clip
brew cask install sitesucker
brew cask install skype
brew cask install slack
brew cask install torbrowser
brew cask install tunnelblick
brew cask install vagrant
brew cask install virtualbox
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
# pip install ipython

# vim swap & backup directory

# Geeknote http://www.geeknote.me/install/
mkdir ~/tmp
