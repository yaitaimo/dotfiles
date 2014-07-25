" Vi互換モードをオフ
set nocompatible

" スワップ設定
" スワップファイルを作成
set swapfile
" スワップファイルの生成先を選択
set directory=.,~/tmp,/var/tmp,/tmp

" バックアップ設定
" 上書きに失敗した場合のみバックアップをとる
set nobackup
set writebackup
" バックアップファイルの保存先を設定
set backupdir=.,~/tmp,~/

filetype off

"--------------- 
" neobundle設定 
"--------------- 
if has('vim_starting') 
  set runtimepath+=~/.vim/bundle/neobundle.vim 
  call neobundle#rc(expand('~/.vim/bundle')) 
endif

"--------------------
" プラグインのリスト
"--------------------
NeoBundle 'git@github.com:Shougo/neobundle.vim.git'
NeoBundle 'git@github.com:Shougo/unite.vim.git'
NeoBundle 'git@github.com:Shougo/neomru.vim.git'
NeoBundle 'git@github.com:Shougo/vimfiler.vim.git'
NeoBundle 'git@github.com:Lokaltog/vim-powerline.git'
NeoBundle 'git@github.com:altercation/vim-colors-solarized.git'
NeoBundle 'git@github.com:Shougo/vimshell.vim.git'
NeoBundle 'git@github.com:mitsuhiko/vim-jinja.git'

NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \   'windows' : 'make -f make_mingw32.mak',
      \   'cygwin' : 'make -f make_cygwin.mak',
      \   'mac' : 'make -f make_mac.mak',
      \   'unix' : 'make -f make_uix.mak',
      \   }
      \ }
NeoBundle 'git@github.com:jcf/vim-latex.git'

if has('lua')
    NeoBundle 'git@github.com:Shougo/neocomplete.vim.git'
endif

filetype indent plugin on

""---------------------
""  カラーテーマの変更
""----------------------
syntax on
set background=dark
let g:solarized_termtrans=1
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

""----------------------
""  vim-powerlineの設定
""----------------------
"powerlineで矢印を使う iTremでfontはpowerline用の物を指定
let g:Powerline_symbols='fancy'
set t_Co=256  "色数設定

""------------
""  表示設定
""------------
set modeline
set title ""編集中のファイル名を表示
set showmatch ""括弧入力時の対応する括弧を表示
set matchtime=3             "" 対応括弧の瞬間強調時間
set ruler
set laststatus=2
set visualbell
set mouse=a
"" カーソル行をハイライト
set cursorline

""-------------
""  Python
""-------------
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd FileType python setl textwidth=79
autocmd FileType python setl formatoptions+=tcqw
""-------------
""  編集設定
""-------------
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set smartindent ""オートインデント
set wildmenu ""コマンドライン補完を便利に

""タブをスペースで挿入
set expandtab
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

""クリップボード設定
set clipboard=unnamed,autoselect

""-----------
""  検索設定
""-----------
set ignorecase ""大文字小文字の区別なく検索
set smartcase ""検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan ""検索時に最後までいったら最初に戻る

""----------
"" 移動設定
""----------
nmap j gj
nmap k gk

""--------------------------------
""  Key Bindings for Insert Mode
""--------------------------------
""移動
imap <C-a> <Home>
imap <C-e> <End>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-n> <Down>
imap <C-p> <UP>
""消去
imap <C-h> <BS>
imap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>
" imap <C-y> <ESC>pi
imap <C-d> <Del>
set whichwrap=h,l,<,>
set backspace=start,eol,indent

""--------------------------------------
""  Key Bindings for Command-line Mode
""--------------------------------------
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

""-----------------------------
""  Unite設定
""-----------------------------
nnoremap [unite] <Nop>
nmap ; [unite]
"開いていない場合はカレントディレクトリ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    "ESCでuniteを終了
    nmap <buffer> <ESC> <Plug>(unite_exit)
    map <C-a> <Home>
    imap <C-e> <End>
    map <C-b> <Left>
    map <C-f> <Right>
    map <C-n> <Down>
    map <C-p> <UP>
    map <C-h> <BS>
    "ctrl+sで縦に分割して開く
    nnoremap <silent><buffer><expr> <C-j> unite#do_action('split')
    inoremap <silent><buffer><expr> <C-j> unite#do_action('split')
    "ctrl+vで横に分割して開く
    nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
endfunction"}}}
let g:unite_source_history_yank_enable =1
nnoremap -sf :<C-u>VimFilerCurrentDir -split<CR>
nnoremap ;e :<C-u>VimFiler -buffer-name=explorer 
            \-split -simple -winwidth=35 -toggle -no-quit<CR>
nnoremap ;s :<C-u>VimShell<CR>
nnoremap ;S :<C-u>VimShell -split<CR>
nnoremap ;r :<C-u>source ~/.vimrc<CR>
nnoremap ;hf :<C-u>Unite file_mru<CR>
nnoremap ;hy :<C-u>Unite history/yank<CR>

""-----------------------------
""  Vim-LaTeX settings
""-----------------------------
let s:bundle = neobundle#get("vim-latex")
function! s:bundle.hooks.on_source(bundle)
  let OSTYPE = system('uname')
  if OSTYPE == "Darwin\n"
    set shellslash
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor='latex'
    let g:Imap_UsePlaceHolders = 1
    let g:Imap_DeleteEmptyPlaceHolders = 1
    let g:Imap_StickyPlaceHolders = 0
    let g:Tex_DefaultTargetFormat = 'pdf'
    let g:Tex_FormatDependency_pdf = 'dvi,pdf'
    let g:Tex_FormatDependency_ps = 'dvi,ps'
    let g:Tex_CompileRule_dvi = '/usr/texbin/platex -shell-escape -interaction=nonstopmode $*'
    let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'
    let g:Tex_BibtexFlavor = '/usr/texbin/pbibtex'
    let g:Tex_ViewRule_dvi = '/usr/bin/open -a Preview'
    let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview'
  endif
endfunction
unlet s:bundle

""-----------------------------
""  NeoComplete
""-----------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

""-----------------------------
""  VimShell
""-----------------------------
let g:vimshell_right_prompt='Get_git_detail()'
let g:vimshell_user_prompt = 'getcwd()'

function! Get_git_detail()
    let s:branch = substitute(system("git rev-parse --abbrev-ref HEAD 2> /dev/null"), '\n', '', 'g')
    if s:branch == ''
        return ''
    else
        return '[= ' . s:branch . ']'
    endif
endfunction
