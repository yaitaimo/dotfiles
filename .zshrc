# Android NDK 設定用
NDK_ROOT=/Applications/android-ndk
export NDK_ROOT

# nvm
source $HOME/.nvm/nvm.sh

# 色使い
autoload colors
colors

alias safari="open -a Safari"

alias pyenv=". /Library/WebServer/Documents/myproject/env/bin/activate"

# tmuxのセット
#alias tmux='tmuxx.sh'

alias localhost="cd /Library/WebServer/Documents"

# パス通し
PATH=/usr/local/bin:$PATH:/Applications/gnuplot.app:$HOME/bin:/Applications/android-sdk-macosx/tools:/Applications/Xcode.app/Contents/developer/Platforms/iPhoneSimulator.platform/Developer/Applications:~/bin

export PATH

# javaの環境変数にutf-8を設定
# export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
