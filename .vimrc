if &compatible
  set nocompatible
endif

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein設定 {{{

" プラグイン置き場
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let g:rc_dir = expand('~/.vim/rc')
    let s:toml = g:rc_dir . '/dein.toml'
    let s:tomllazy = g:rc_dir . '/deinlazy.toml'

    " TOML を読み込み、キャッシュしておく
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:tomllazy, {'lazy': 1})
     
    call dein#add('Shougo/deoplete.nvim')
    if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable

" }}}

" Display {{{
set modeline
set title ""編集中のファイル名を表示
set showmatch ""括弧入力時の対応する括弧を表示
set matchtime=3             "" 対応括弧の瞬間強調時間
set ruler
set laststatus=2
set number
set visualbell
set mouse=a
set cursorline
set termguicolors
" }}}

" Folding {{{
set foldmethod=marker
" }}}

" FileType Setting {{{
" TXT {{{
autocmd BufRead,BufNewFile *.txt setlocal ft=txt
autocmd FileType txt setl tabstop=2 expandtab softtabstop=2 shiftwidth=2
" }}}

" Python {{{
autocmd FileType python setl 
            \ cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd FileType python setl textwidth=79
autocmd FileType python setl formatoptions+=tcqw
" }}}

" Ruby {{{
autocmd FileType ruby setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
autocmd FileType ruby setl textwidth=79
autocmd FileType ruby setl formatoptions+=tcqw
" }}}

" eruby {{{
autocmd FileType eruby setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
" }}}

" slim {{{
autocmd BufRead,BufNewFile *.slim setlocal filetype=slim
" }}}

" tex {{{
let g:tex_flavor = "latex"
autocmd FileType tex setl formatoptions+=mM textwidth=79
" }}}

" JavaScript {{{
autocmd FileType javascript setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
" }}}

" SCSS {{{
autocmd FileType scss setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
" }}}

" YAML {{{
autocmd FileType yaml setl tabstop=2 expandtab shiftwidth=2 softtabstop=2
" }}}

" }}}

" Swap & Backup {{{
" スワップ設定
" スワップファイルを作成
set swapfile
" スワップファイルの生成先を選択
set directory=~/tmp,/var/tmp,/tmp

" バックアップ設定
" 上書きに失敗した場合のみバックアップをとる
set nobackup
set writebackup
" バックアップファイルの保存先を設定
set backupdir=~/tmp,~/
" }}}

" Editing {{{
set termencoding=utf-8
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,utf-8,sjis
" set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8
function! SetFileEncoding()
    if search("[^\x01-\x7E]", 'n') == 0 && &modifiable
        set fenc=
    endif
endfunction
au BufReadPost * call SetFileEncoding()

set fileformats=unix,dos,mac
"set smartindent スマートインデントはいらない。filetype indent onが正解。
set wildmenu ""コマンドライン補完を便利に
set hidden ""undoの履歴をbufferでも有効に
set whichwrap=<,>
set backspace=start,eol,indent

""タブをスペースで挿入
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=4

""クリップボード設定
set clipboard=unnamedplus " copy to the system clipboard
" }}}

" 検索設定 {{{
set ignorecase ""大文字小文字の区別なく検索
set smartcase ""検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan ""検索時に最後までいったら最初に戻る
" }}}

" Key Bindings & Shortcuts {{{

nmap ; [start]

nnoremap j gj
nnoremap k gk

nnoremap <Space>d :<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>kdd
nnoremap <Space>l O<ESC>78i-<ESC>
let config_path = "$HOME/.config/nvim/init.vim"
nnoremap <silent> .r :execute 'source' . config_path<CR>
nnoremap <silent> .e :execute 'edit' . config_path<CR>
" あまりに押し間違いが多いので．
nnoremap [start]n :<C-u>set nonumber!<CR>

nnoremap [start]r :<C-u>QuickRun<CR>
" tagsジャンプの際に複数ある場合を考慮
" nnoremap [start]t :<C-u>TagbarToggle<CR>

nnoremap <silent> <C-b>D :bd!<CR>
nnoremap <silent> <C-b>d :bd<CR>
nnoremap <silent> <C-w>n :enew<CR>

nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabedit<CR>
nnoremap <silent> ts :<C-u>tab sp<CR>

nmap <Esc><Esc> :<C-u>cclose<CR>

if has('nvim')
    function! OpenTerminal()
        let pattern = "term://"
        let bufcount = bufnr("$")
        let currbufnr = 1
        let matchingbufnr = -1
        while currbufnr <= bufcount
            if(bufexists(currbufnr))
                let currbufname = bufname(currbufnr)
                if(match(currbufname, pattern) > -1)
                    let matchingbufnr = currbufnr
                endif
            endif
            let currbufnr = currbufnr + 1
        endwhile
        if(matchingbufnr > -1)
            execute ":buffer ". matchingbufnr
        else
            execute ":terminal"
        endif
    endfunction
    
    nnoremap <silent> <Space>t :<C-u>vsplit<CR>:call OpenTerminal()<CR>i
    tnoremap <ESC> <C-\><C-n>
    tnoremap <ESC><ESC> <C-\><C-n>:<C-u>hide<CR>
endif

" }}}

" Key Bindings & Shortcuts for Insert Mode {{{
" 移動
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <UP>
inoremap <C-k> <C-o>d$
inoremap <Nul> <C-n>

" 消去
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <F5> <C-r>=strftime('%Y-%m-%d %H:%M:%S')<Return>
" }}}

" Key Bindings for Visual Mode {{{
" 選択部分を入力として検索
vnoremap * "zy:let @/ = @z<CR>n
" }}}

" Key Bindings & Shortcuts for Command-line Mode {{{
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-h>  <BS>
cnoremap <C-d>  <Del>
cnoremap <C-p>  <Up>
cnoremap <C-n>  <Down>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
            \ '' : getcmdline()[:getcmdpos()-2]<CR>
" }}}

" Copy File name & path {{{
" File path
function! g:CopyFilePath()
  let @* = expand("%:p")
  echo @*
endfunction
 
" File name
function! g:CopyFileName()
  let @* = expand("%:t")
  echo @*
endfunction
 
" Directory path
function! g:CopyDirectoryPath()
  let @* = expand("%:p:h")
  echo @*
endfunction
 
" コマンドとして実行できるようにする
command! CopyFilePath :call g:CopyFilePath()
command! CopyFileName :call g:CopyFileName()
command! CopyDirectoryPath :call g:CopyDirectoryPath()

nnoremap [start]cfp :<C-u>CopyFilePath<CR>
nnoremap [start]cfn :<C-u>CopyFileName<CR>
nnoremap [start]cdp :<C-u>CopyDirectoryPath<CR>

" }}}

" Local config {{{
if filereadable($HOME."/.config/nvim/local.vim")
    so $HOME/.config/nvim/local.vim
endif
" }}}

" vim: foldmethod=marker
