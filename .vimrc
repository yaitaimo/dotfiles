"
"Last Changed
"2013/02/01 (金) 15:53
"2013/07/05 (金) 14:15
"

""--------------
""  Vundle設定
""--------------
set nocompatible
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
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'https://github.com/Shougo/vimshell.git'
NeoBundle 'https://github.com/Shougo/vimproc'
NeoBundle 'git://github.com/Lokaltog/vim-powerline.git'
NeoBundle 'git://github.com/altercation/vim-colors-solarized.git'

filetype plugin on
filetype indent on

""---------------------
""  カラーテーマの変更
""----------------------
syntax enable
set background=dark
let g:solarized_termtrans=1
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized

""----------------------
""  vim-powerlineの設定
""----------------------
set guifont=Inconsolata_for_Powerline:h11:cANSI
let g:Powerline_symbols='fancy'

""------------
""  表示設定
""------------
set title ""編集中のファイル名を表示
set showmatch ""括弧入力時の対応する括弧を表示
set matchtime=3             "" 対応括弧の瞬間強調時間
set ruler
set laststatus=2
set visualbell
"" カーソル行をハイライト
set cursorline
"highlight CursorLine cterm=none ctermbg=Black

""-------------
""  編集設定
""-------------
set termencoding=utf-8
set encoding=utf-8
"set fileencodings=iso-2022-jp,utf-8,cp932,euc-jp

set smartindent ""オートインデント
set wildmenu ""コマンドライン補完を便利に
set autoindent
""タブをスペースで挿入(2スペース)
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=0
""jsは2スペース
autocmd BufNewFile,BufRead *.js set tabstop=2
autocmd BufNewFile,BufRead *.js set shiftwidth=2
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

""-----------------------------
""  insert_modeでのカーソル操作
""------------------------------
""移動
imap <C-a> <Home>
imap <C-e> <End>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-n> <Down>
imap <C-p> <UP>
""消去
imap <C-h> <BS>
imap <C-k> <ESC>ld$a
imap <C-y> <ESC>pi
imap <C-d> <delete>
set whichwrap=h,l,<,>
set backspace=start,eol,indent

""-----------------------------
""  キーボードコマンド設定
""-----------------------------
""insert_modeで \date タイムスタンプを挿入する
imap <Leader>date <C-R>=strftime('%Y/%m/%d (%a) %H:%M')<CR>
""perl debug用コマンド
imap <Leader>dump <C-R> Trace(Data::Dumper::Dumper );<Left><Left>
