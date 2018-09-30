Install with `git clone --recursive git@github.com:yaitaimo/dotfiles.git`

## NeoVim
vim8 や neovim で python3 を扱う場合に、global で良いライブラリは global で管理し、  
`~/.vimrc.local` に以下のようにパスを設定しておく。
`let g:python3_host_prog = '/Users/yu/.pyenv/shims/python3`
