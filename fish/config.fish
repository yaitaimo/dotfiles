# 基本設定
set -x EDITOR vim
set -x LC_CTYPE ja_JP.UTF-8
set -x LANG ja_JP.UTF-8

# fzf 設定
set -x FZF_COMPLETE 1
set -x FZF_DEFAULT_OPTS "--reverse --height 40%"
set -x FZF_DEFAULT_COMMAND 'ag -g ""'

# エイリアス設定
alias g 'git'
alias grep 'grep --color=auto'
alias la 'ls -lahG'
alias ll 'ls -lhG'
alias ls 'ls -hG'
alias v 'nvim'

# ASDF バージョン管理
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# ローカル設定
set local_config_path ~/.config/fish/local.fish
if test -e $local_config_path
    source $local_config_path
end
