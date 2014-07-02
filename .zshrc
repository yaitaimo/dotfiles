
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
PATH=/usr/local/bin:$PATH:$HOME/bin
#:/Applications/android-sdk-macosx/tools:/Applications/Xcode.app/Contents/developer/Platforms/iPhoneSimulator.platform/Developer/Applications:

export PATH

# javaの環境変数にutf-8を設定
# export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8

# localhostコマンドを追加
alias inet="ifconfig | grep en0 -A 4 | grep 'inet ' | cut -f 2,2 -d ' '"

proxy="proxy.kuins.net:8080"
switch_trigger="lab"

if [ "`networksetup -getcurrentlocation`" = "$switch_trigger" ];then
    export http_proxy=$proxy
    export ftp_proxy=$proxy
else
    unset http_proxy
    unset ftp_proxy
fi

alias wifi_changer='python ~/MyCode/python/gem/wifi_changer.py'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
