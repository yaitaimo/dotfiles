set -x EDITOR vim
set -x LC_CTYPE "ja_JP.UTF-8"
set -x PATH /usr/local/bin $PATH

eval (direnv hook fish)

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

  set_color cyan
  printf '[%s] ' (whoami)
  set_color normal

  set_color yellow
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s' (__fish_git_prompt)

  printf '\n$ '
end

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

function reload
    source ~/.config/fish/config.fish
end
