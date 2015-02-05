# General {{{

export EDITOR=vim           # エディタをvimに設定
export LANG=ja_JP.UTF-8     # 文字コードをUTF-8に設定
export LC_ALL=ja_JP.UTF-8 
export KCODE=u              # KCODEにUTF-8を設定

bindkey -e                  # emacsキーバインド(mac default)

setopt no_beep              # ビープ音なし
setopt auto_cd              # ディレクトリ名の入力のみで移動する
setopt auto_pushd           # cdをpushdとして扱う
setopt pushd_ignore_dups    # 重複するディレクトリは記録しないようにする
setopt correct

export CLICOLOR=true        # lsコマンド時、自動で色がつく(ls -Gのようなもの？）
bindkey "^W" forward-word   # forward-word

autoload -U colors; colors

stty stop undef
stty start undef

autoload -U compinit
compinit
setopt auto_list
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時の大文字小文字を区別しない

# }}}

# History {{{

HISTFILE=~/.zsh_history # ヒストリーを保存するファイル
HISTSIZE=100000          # メモリに保存されるヒストリの件数
SAVEHIST=100000          # 保存されるヒストリの件数
setopt extended_history # ヒストリに実行時間も保存する
setopt hist_ignore_dups # 直前と同じコマンドはヒストリに追加しない
setopt share_history    # 他のシェルのヒストリをリアルタイムで共有する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 全てのヒストリを表示する
function history-all { history -E 1 | less }

# }}}

# Alias {{{

# 安全志向
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias ll="ls -lA"
alias lf="ls -FA"
alias la="ls -a"
alias p="popd"
alias ]="open"
alias v="vim"

# }}}

# Prompt {{{

setopt prompt_subst
PROMPT='%{${fg[cyan]}%}[%n%{$reset_color%}`prompt-git-current-branch`%{${fg[cyan]}%}]%{${reset_color}%} %{${fg[yellow]}%}%~%{${reset_color}%}
$'
# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;

# %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
# これをしないと右プロンプトの位置がずれる
function prompt-git-current-branch { # {{{
local name st color
if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
fi
name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
if [[ -z $name ]]; then
    return
fi
st=`git status 2> /dev/null`
if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=${fg[cyan]}
elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=${fg[yellow]}
elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=${fg_bold[red]}
else
    color=${fg[red]}
fi
echo "%{${fg[cyan]}%}|%{$reset_color%}%{$color%}$name%{$reset_color%}"
} # }}}

# }}}

# For mac {{{
if [[ $(uname) == Darwin  ]]; then

    # Add alias for ctags in Vim
    # alias ctags="/usr/local/bin/ctags"

    # zmvのセット
    autoload -Uz zmv
    alias zmv='noglob zmv -W'

    # alias chrome='open -a Google\ Chrome'

fi
# }}}

# Load the local configuration.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

