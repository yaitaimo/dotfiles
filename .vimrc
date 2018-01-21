" Detect platform {{{
let os = ""
if has("win32") || has("win64")
    let os="win"
    exit
elseif has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let os="mac"
    else
        let os="unix"
    endif
endif
" }}}

if &compatible
  set nocompatible
endif

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
     
    if os=="mac"
        " QuickRun
        call dein#add('mattn/webapi-vim')
        call dein#add('tyru/open-browser.vim')
        call dein#add('tyru/open-browser-github.vim')
        call dein#add('superbrothers/vim-quickrun-markdown-gfm')
    endif    

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

" Color Theme {{{
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized8
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
highlight CursorLine cterm=NONE ctermbg=black
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
set clipboard+=unnamed " copy to the system clipboard
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
nnoremap .r :<C-u>source ~/dotfiles/.vimrc<CR>
nnoremap <silent> .e :<C-u>edit ~/dotfiles/.vimrc<CR><CR>
" あまりに押し間違いが多いので．
nnoremap [start]n :<C-u>set nonumber!<CR>

nnoremap [start]r :<C-u>QuickRun<CR>
" tagsジャンプの際に複数ある場合を考慮
nnoremap [start]t :<C-u>TagbarToggle<CR>

nnoremap <silent> <C-b>D :bd!<CR>
nnoremap <silent> <C-b>d :bd<CR>
nnoremap <silent> <C-w>n :enew<CR>

nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabedit<CR>
nnoremap <silent> ts :<C-u>tab sp<CR>

nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0zz' : 'l'
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zczz' : 'h'

nmap <Esc><Esc> :<C-u>cclose<CR>

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

" }}}

" Denite {{{
call denite#custom#option('default', 'prompt', '>')

call denite#custom#map('insert', "<C-n>", '<denite:move_to_next_line>')
call denite#custom#map('insert', "<C-p>", '<denite:move_to_previous_line>')

call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('insert', "<C-s>", '<denite:do_action:split>')

call denite#custom#map('normal', "t", '<denite:do_action:tabopen>')
call denite#custom#map('normal', "v", '<denite:do_action:vsplit>')
call denite#custom#map('normal', "s", '<denite:do_action:split>')

"call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>')

" カレントディレクトリ
nnoremap <silent> [start]o :<C-u>DeniteBufferDir file_rec<CR>

" プロジェクト
nnoremap <silent> <C-p> :<C-u>DeniteProjectDir file_rec<CR>

" バッファ
nnoremap <silent> [start]b :<C-u>Denite buffer<CR>

" ヒストリ
nnoremap <silent> [start]h :<C-u>Denite file_mru<CR>

" ヤンクヒストリ
nnoremap <silent> [start]y :<C-u>Denite neoyank<CR>

" 全文検索
" nnoremap <silent> [start]g :<C-u>Denite -buffer-name=search -mode=normal grep<CR>
" 全文検索（カーソル下単語）
" nnoremap <silent> [start]gw :<C-u>DeniteCursorWord grep -buffer-name=search line<CR><C-R><C-W><CR>

nnoremap <silent> [start]gg :<C-u>Ggrep <C-R><C-W><CR>
nnoremap <silent> [start]gd :<C-u>Gdiff<CR>
nnoremap <silent> [start]gs :<C-u>Gstatus<CR>

" }}}

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
" }}}

" open-browser-github.vim{{{
nnoremap <silent> [start]go :<C-u>OpenGithubProject<CR>
" }}}

" Align {{{
let g:Align_xstrlen = 3
" }}}

" jedi-vim {{{
" if neobundle#is_sourced('jedi-vim')
" "    g:jedi#popup_select_first = 0
" autocmd FileType python setlocal completeopt-=preview
" autocmd FileType python setlocal omnifunc=jedi#completions
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0
" 
" if !exists('g:neocomplete#force_omni_input_patterns')
"     let g:neocomplete#force_omni_input_patterns = {}
" endif

" let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
" endif
" }}}

" Vim-LaTeX {{{
if dein#util#_is_mac()
    nnoremap <silent> [start]ll :<C-u>call Tex_StartTex()<CR>
    function! Tex_StartTex()
        call Tex_RunLaTeX()
        call Tex_ViewLaTeX()
    endfunction
    nnoremap <silent> [start]lr :<C-u>call Tex_RunLaTeX()<CR>
    nnoremap <silent> [start]lv :<C-u>call Tex_ViewLaTeX()<CR>
endif
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
 
" Folder path
function! g:CopyFolderPath()
  let @* = expand("%:p:h")
  echo @*
endfunction
 
" コマンドとして実行できるようにする
command! CopyFilePath :call g:CopyFilePath()
command! CopyFileName :call g:CopyFileName()
command! CopyFolderPath :call g:CopyFolderPath()
" }}}

" Local config {{{
if filereadable($HOME."/.vimrc.local")
    so $HOME/.vimrc.local"
endif
" }}}

" vim: foldmethod=marker
