# 基本設定
set -x EDITOR vim
set -x LC_CTYPE ja_JP.UTF-8
set -x LANG ja_JP.UTF-8

starship init fish | source

# fzf 設定
set -x FZF_COMPLETE 1
set -x FZF_DEFAULT_OPTS "--reverse --height 40%"
set -x FZF_DEFAULT_COMMAND 'ag -g ""'

# エイリアス設定
alias dc 'docker compose'
alias g 'git'
alias grep 'grep --color=auto'
alias la 'ls -lahG'
alias ll 'ls -lhG'
alias ls 'ls -hG'
alias v 'nvim'
alias lg 'lazygit'

# ローカル設定
set local_config_path ~/.config/fish/local.fish
if test -e $local_config_path
    source $local_config_path
end
