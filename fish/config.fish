set -x EDITOR vim
set -x LC_CTYPE ja_JP.UTF-8
set -x LANG ja_JP.UTF-8

# git on prompt
set __fish_git_prompt_showdirtystate yes
set __fish_git_prompt_showstashstate yes

set __fish_git_prompt_showcolorhints yes

set __fish_git_prompt_char_upstream_ahead "↑"
set __fish_git_prompt_char_upstream_behind "↓"
set __fish_git_prompt_char_upstream_prefix ""

set __fish_git_prompt_char_stagedstate "●"
set __fish_git_prompt_char_dirtystate "+"
set __fish_git_prompt_char_untrackedfiles "…"
set __fish_git_prompt_char_conflictedstate "×"
set __fish_git_prompt_char_cleanstate "✓"

set __fish_git_prompt_color_dirtystate red
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_invalidstate blue
set __fish_git_prompt_color_untrackedfiles red
set __fish_git_prompt_color_cleanstate cyan

function fish_prompt
  set last_status $status

  if set -q VIRTUAL_ENV
    echo -n -s (set_color white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
  end

  set_color cyan
  printf '[%s] ' (whoami)
  set_color normal

  set_color yellow
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s' (__fish_git_prompt)

  printf '\n$ '
end

# fzf config
set -x FZF_COMPLETE 1
set -x FZF_DEFAULT_OPTS "--reverse --height 40%"
set -x FZF_DEFAULT_COMMAND 'ag -g ""'

function fssh -d "Fuzzy-find ssh host and ssh into it"
  ag '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | xargs -o ssh
end

# alias
alias v 'nvim'
alias ls 'ls -hG'
alias ll 'ls -lhG'
alias la 'ls -lahG'
alias grep 'grep --color=auto'

alias g 'git'
alias gd 'git diff'
alias gs 'git status'
alias gl 'git log'
alias gf 'git fetch'
alias ga 'git add'
alias gc 'git commit -m'
alias gb 'git branch'

function workspace_search -d 'Workspace search'
    set -l selector
    [ -n "$WORKSPACE_SELECTOR" ]; and set selector $WORKSPACE_SELECTOR; or set selector fzf
    set -l selector_options
    [ -n "$WORKSPACE_SELECTOR_OPTS" ]; and set selector_options $WORKSPACE_SELECTOR_OPTS

    if not type -qf $selector
        printf "\nERROR: '$selector' not found.\n"
        return 1
    end

    set -l query (commandline -b)
    [ -n "$query" ]; and set flags --query="$query"; or set flags
    switch "$selector"
        case fzf fzf-tmux peco percol fzy sk
            ls ~/Workspace | "$selector" $selector_options $flags | read select
        case \*
            printf "\nERROR.\n"
    end
    [ -n "$select" ]; and cd ~/Workspace/"$select"
    commandline -f repaint
end

function fish_user_key_bindings
  bind \cw workspace_search
end

source ~/.asdf/asdf.fish

# reload
function reload
    source ~/.config/fish/config.fish
end

# load local settings
set local_config_path ~/.config/fish/local.fish
if test -e $local_config_path
    source $local_config_path
end
