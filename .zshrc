
# Android NDK 設定用
NDK_ROOT=/Applications/android-ndk
export NDK_ROOT

# nvm
source $HOME/.nvm/nvm.sh

alias safari="open -a Safari"

# tmuxのセット
alias tmux='~/bin/tmuxx.sh'

alias localhost="cd /Library/WebServer/Documents"

# パス通し
PATH=/usr/local/bin:$PATH:/Applications/gnuplot.app:$HOME/bin:/Applications/android-sdk-macosx/tools:/Applications/Xcode.app/Contents/developer/Platforms/iPhoneSimulator.platform/Developer/Applications:~/bin

export PATH

# javaの環境変数にutf-8を設定
# export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

# localhostコマンドを追加
alias inet="ifconfig | grep en0 -A 4 | grep 'inet ' | cut -f 2,2 -d ' '"

