# General {{{

export EDITOR=vim           # エディタをvimに設定
export LANG=ja_JP.UTF-8     # 文字コードをUTF-8に設定
export LC_ALL=ja_JP.UTF-8 
export KCODE=u              # KCODEにUTF-8を設定

bindkey -e                  # emacsキーバインド(mac default)

autoload -U edit-command-line
zle -N edit-command-line
bindkey "^o" edit-command-line

setopt no_beep              # ビープ音なし
setopt auto_cd              # ディレクトリ名の入力のみで移動する
setopt auto_pushd           # cdをpushdとして扱う
setopt pushd_ignore_dups    # 重複するディレクトリは記録しないようにする
setopt correct

export CLICOLOR=true        # lsコマンド時、自動で色がつく(ls -Gのようなもの？）
bindkey "^w" backward-word

autoload -U colors; colors

stty stop undef
stty start undef

autoload -U compinit
compinit
setopt auto_list
setopt auto_menu
setopt auto_resume
setopt auto_name_dirs
unsetopt menu_complete
setopt magic_equal_subst
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}" # 補完時の大文字小文字を区別しない
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' verbose yes
zstyle ':completion:*'  _expand _complete _match _prefix _approximate _list _history
# zstyle ':completion:*' completer
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*:*:cdr:*:*' menu selection
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-max 500
    zstyle ':chpwd:*' recent-dirs-default true
    # zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
    zstyle ':chpwd:*' recent-dirs-pushd true
fi

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''
# }}}

# History {{{

HISTFILE=~/.zsh_history # ヒストリーを保存するファイル
HISTSIZE=100000          # メモリに保存されるヒストリの件数
SAVEHIST=100000          # 保存されるヒストリの件数
setopt extended_history # ヒストリに実行時間も保存する
setopt hist_ignore_dups # 直前と同じコマンドはヒストリに追加しない

# 重複するコマンドが保存されるとき、古い方を削除する。
setopt hist_save_no_dups
setopt hist_ignore_all_dups

# 複数の zsh を同時に使う 
setopt share_history    # 他のシェルのヒストリをリアルタイムで共有する
setopt append_history   # history ファイルに上書きせず追加する

# コマンドラインの先頭がスペースで始まる場合ヒストリに追加しない
setopt hist_ignore_space

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

alias rm="rm -i"
alias ll="ls -lA"
alias lf="ls -FA"
alias la="ls -a"
alias p="popd"
alias ]="open"
alias t="todo.sh"

# vim {{{
alias v="vim"
alias vh="vim -c ':Unite file_mru'"
alias vml="vim -c ':MemoList'"
alias vmn="vim -c ':MemoNew'"
alias vrc="vim ~/dotfiles/.vimrc"
# }}}

# git {{{
alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gca="git commit -am"
alias gp="git push"
alias gpl="git pull"
alias gd="git diff"
alias gdl="git diff --stat -r"
alias gb="git branch"
alias gba="git branch -a"
alias gs="git status"
alias gl="git log"
alias gm="git merge"
alias gco="git checkout"
# }}}

alias c="cd"
alias ..=" cd ..; ls"
alias ...=" cd ..; cd ..; ls"
alias ....=" cd ..; cd ..; cd ..; ls"

# brew {{{
alias b="brew"
alias bs="brew search"
alias bi="brew install"
alias bup="brew update; brew upgrade --all;"
# }}}

# Suffix Alias {{{
alias -s md="vim"
alias -s txt="vim"
alias -s py="vim"
alias -s gitignore="vim"
alias -s gitconfig="vim"
alias -s php="vim"
# alias -s sh="vim"

alias -s avi="open"
alias -s AVI="open"
alias -s mov="open"
alias -s mpg="open"
alias -s m4v="open"
alias -s mp4="open"
alias -s rmvb="open"
alias -s MP4="open"
alias -s ogg="open"
alias -s ogv="open"
alias -s flv="open"
alias -s mkv="open"
alias -s wav="open"
alias -s mp3="open"
alias -s webm="open"

alias -s pdf="open"
alias -s PDF="open"
alias -s tif="open"
alias -s tiff="open"
alias -s png="open"
alias -s jpg="open"
alias -s jpeg="open"
alias -s JPG="open"
alias -s gif="open"
alias -s psd="open"
# }}}

# tmux Alias {{{
alias tm="tmux"
alias tma="tmux a -t"
alias tmn="tmux new -s"
alias tml="tmux ls"
# }}}

setopt extended_glob
typeset -A abbreviations
abbreviations=(
"G" "| grep"
"L" "| less"
"W" "| wc"
"T" "| tail -f"
# 'gc' 'gc "__CURSOR__"'
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    # [[ $abbreviations[$MATCH] ]] && RBUFFER=${LBUFFER[(ws:__CURSOR__:)2]}
    # [[ $abbreviations[$MATCH] ]] && LBUFFER=${LBUFFER[(ws:__CURSOR__:)1]}
    zle self-insert
}

no-magic-abbrev-expand() {
    #LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# }}}

# Prompt {{{

# %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する

function prompt-git-current-branch { # {{{
local name st color
if [[ $PWD =~ '/\.git(/.*)?$' ]]; then
    return
fi
name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
if [[ -z $name ]]; then
    return
fi
st=`git status 2> /dev/null`
if [[ -n `echo $st | grep "^nothing to"` ]]; then
    color=${fg[cyan]}
elif [[ -n `echo $st | grep "^nothing added"` ]]; then
    color=${fg[yellow]}
elif [[ -n `echo $st | grep "^# Untracked"` ]]; then
    color=${fg_bold[red]}
else
    color=${fg[red]}
fi
echo "%{${fg[cyan]}%}|%{$reset_color%}%{$color%}$name%{$reset_color%}"
} # }}}

setopt prompt_subst
PROMPT='%{${fg[cyan]}%}[%n%{$reset_color%}`prompt-git-current-branch`%{${fg[cyan]}%}]%{${reset_color}%} %{${fg[yellow]}%}%~%{${reset_color}%}
$'
# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    #PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;

# }}}

# For mac {{{
if [[ $(uname) == Darwin  ]]; then

    # Add alias for ctags in Vim
    # alias ctags="/usr/local/bin/ctags"

    # zmvのセット
    autoload -Uz zmv
    alias zmv="noglob zmv -W"

    [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

    # alias chrome="open -a Google\ Chrome"

fi
# }}}

# about Ruby
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Load the local configuration.
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local


