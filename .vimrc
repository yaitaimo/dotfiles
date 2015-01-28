" Detect platform {{{
let os = ""
if has("win32")
    let os="win"
elseif has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        let os="mac"
    else
        let os="unix"
    endif
endif
" }}}

" neobundle設定 {{{

filetype off

if has('vim_starting') 
    if &compatible
        set nocompatible
    endif
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle')) 

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Plugins {{{
NeoBundle 'Lokaltog/powerline'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'tpope/vim-fugitive'

NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \   'windows' : 'make -f make_mingw32.mak',
            \   'cygwin' : 'make -f make_cygwin.mak',
            \   'mac' : 'make -f make_mac.mak',
            \   'unix' : 'make -f make_uix.mak',
            \   }
            \ }

NeoBundleLazy 'Shougo/vimfiler.vim', {
            \   'autoload' : { 'commands' : [ "VimFilerTab", "VimFiler",
            \   "VimFilerExplorer" ] } 
            \ }
if os=="mac"
    NeoBundleLazy 'jcf/vim-latex', {
                \ "autoload": {"filetypes": ["tex"]}}
endif    

" QuickRun
NeoBundle 'tyru/open-browser.vim'
NeoBundle "thinca/vim-quickrun"

NeoBundle 'majutsushi/tagbar'

" For flask develop
NeoBundleLazy 'mitsuhiko/vim-jinja', {
            \ "autoload": {
            \   "filetypes": ["python", "python3", "djangohtml"],
            \ }}

NeoBundleLazy "vim-scripts/python_fold", {
            \ "autoload": {
            \   "filetypes": ["python", "python3", "djangohtml"],
            \ }}
NeoBundleLazy "davidhalter/jedi-vim", {
            \ "autoload": {
            \   "filetypes": ["python", "python3", "djangohtml"],
            \ },
            \ "build": {
            \   "mac": "pip install jedi",
            \   "unix": "pip install jedi",
            \ }}

if has('lua') && v:version >= 703 && has('patch885')
    NeoBundleLazy 'Shougo/neocomplete.vim'
else
    NeoBundleLazy 'Shougo/neocomplcache.vim'
endif
" }}}

call neobundle#end()

filetype plugin indent on

" インストールされてないプラグインのチェック及びダウンロード
NeoBundleCheck 
" }}}

" カラーテーマの変更 {{{
syntax on
set background=dark
let g:solarized_termtrans=1
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized
" }}}

" powerlineの設定 {{{
"powerlineで矢印を使う iTremでfontはpowerline用の物を指定
set laststatus=2
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_symbols = 'fancy'
set t_Co=256  "色数設定
set noshowmode
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
"" カーソル行をハイライト
"set cursorline
" }}}

" Folding {{{
set foldmethod=marker
" }}}

" Python {{{
autocmd FileType python setl 
            \ cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
autocmd FileType python setl textwidth=79
autocmd FileType python setl formatoptions+=tcqw
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

" 編集設定 {{{
set termencoding=utf-8
set encoding=utf-8
set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8
au BufReadPost * if search("[^\x01-\x7E]", 'n') == 0 |
                        \ set fenc= | endif
set fileformats=unix,dos,mac
"set smartindent スマートインデントはいらない。filetype indent onが正解。
set wildmenu ""コマンドライン補完を便利に
set hidden ""undoの履歴をbufferでも有効に
set whichwrap=<,>
set backspace=start,eol,indent

""タブをスペースで挿入
set expandtab
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

set formatoptions+=mM
set textwidth=78

""クリップボード設定
set clipboard=unnamed
" }}}

" 検索設定 {{{
set ignorecase ""大文字小文字の区別なく検索
set smartcase ""検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan ""検索時に最後までいったら最初に戻る
" }}}

" Key Bindings {{{

" Key Bindings for Normal Mode {{{
nnoremap [start] <Nop>
nmap ; [start]

nnoremap j gj
nnoremap k gk

nnoremap <Space>d :<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>
nnoremap [start]e :<C-u>VimFiler -buffer-name=explorer 
            \ -split -simple -winwidth=35 -toggle -no-quit<CR>
nnoremap [start]s :<C-u>VimShell<CR>
nnoremap [start]S :<C-u>VimShell -split<CR>
nnoremap .r :<C-u>source ~/dotfiles/.vimrc<CR>
nnoremap .e :<C-u>edit ~/dotfiles/.vimrc<CR>
" あまりに押し間違いが多いので．
nnoremap q: :<C-u>

nnoremap [start]r :<C-u>QuickRun<CR>
" tagsジャンプの際に複数ある場合を考慮
nnoremap [start]g <C-]>
nnoremap [start]t :TagbarToggle<CR>

nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0zz' : 'l'
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zczz' : 'h'
" }}}

" Key Bindings for Insert Mode {{{
" 移動
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <UP>
inoremap <C-k> <C-o>d$

" 消去
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <F5> <C-r>=strftime('%Y-%m-%d %H:%M:%S')<Return>
" }}}

" Key Bindings for Visual Mode {{{
" 選択部分を入力として検索
vnoremap * "zy:let @/ = @z<CR>n
" }}}

" Key Bindings for Command-line Mode {{{
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

" Unite {{{
"開いていない場合はカレントディレクトリ
nnoremap <silent> [start]f :<C-u>UniteWithBufferDir file file/new<CR> 
nnoremap <silent> [start]m :<C-u>Unite file:~/tmp file/new:~/tmp<CR>
nnoremap <silent> [start]b :<C-u>Unite buffer<CR>
nnoremap <silent> [start]h :<C-u>Unite file_mru<CR>
nnoremap <silent> [start]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [start]a :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [start]y :<C-u>Unite history/yank<CR>
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    "ESCでuniteを終了
    nnoremap <buffer> <ESC> <Plug>(unite_exit)
    inoremap <C-a> <Home>
    inoremap <C-e> <End>
    inoremap <C-b> <Left>
    inoremap <C-f> <Right>
    inoremap <C-n> <Down>
    inoremap <C-p> <UP>
    inoremap <C-h> <BS>
    "ctrl+sで縦に分割して開く
    nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
    inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
    "ctrl+vで横に分割して開く
    nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
endfunction" }}}
let g:unite_source_history_yank_enable =1
" }}}

" Vim-LaTeX {{{
let s:bundle = neobundle#get("vim-latex")
function! s:bundle.hooks.on_source(bundle)
    nnoremap <silent> [start]ll :<C-u>call Tex_StartTex()<CR>
    function! Tex_StartTex()
        call Tex_RunLaTeX()
        call Tex_ViewLaTeX()
    endfunction
    nnoremap <silent> [start]lr :<C-u>call Tex_RunLaTeX()<CR>
    nnoremap <silent> [start]lv :<C-u>call Tex_ViewLaTeX()<CR>
    set shellslash
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor='latex'
    let g:Imap_UsePlaceHolders = 1
    let g:Imap_DeleteEmptyPlaceHolders = 1
    let g:Imap_StickyPlaceHolders = 0
    let g:Tex_DefaultTargetFormat = 'pdf'
    let g:Tex_FormatDependency_pdf = 'dvi,pdf'
    let g:Tex_FormatDependency_ps = 'dvi,ps'
    let g:Tex_CompileRule_dvi = '/usr/texbin/platex -shell-escape
                \ -interaction=nonstopmode $*' 
    let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'
    let g:Tex_BibtexFlavor = '/usr/texbin/pbibtex'
    let g:Tex_ViewRule_dvi = '/usr/bin/open -a Preview'
    let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview'
endfunction
unlet s:bundle
" }}}

" NeoComplete & NeoComplCache {{{
if neobundle#is_installed('neocomplete')
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
elseif neobundle#is_installed('neocomplcache')
    let g:neocomplcache_enable_at_startup = 1
    let s:hooks = neobundle#get_hooks("neocomplcache.vim")
    function! s:hooks.on_source(bundle)
        let g:acp_enableAtStartup = 0
        let g:neocomplcache_enable_smart_case = 1
        " NeoComplCacheを有効化
        " NeoComplCacheEnable 
    endfunction
endif
" }}}

" VimShell {{{
let g:vimshell_right_prompt='GetGitDetail()'
let g:vimshell_user_prompt = 'getcwd()'

function! GetGitDetail()
    let s:branch = substitute(
                \ system("git rev-parse --abbrev-ref HEAD 2> /dev/null"),
                \ '\n', '', 'g') 
    if s:branch == '' 
        return ''
    else
        return '[= ' . s:branch . ']'
    endif
endfunction
" }}}

" Ctags {{{
" function! UpdateTagsFile()
"     let current_filetype = &filetype
"     let venv_directory_names = ['env', 'venv']
"     if current_filetype!='' && current_filetype=='py'
"         for name in venv_directory_names
"             if isdirectory(name)
"             endif
"         endfor
"     endif
"     " もしpythonでかつvirtualenvがあれば、それを含む物にする 
" endfunction 
" }}}

" Clear undo history {{{
" A function to clear the undo history
function! <SID>ForgetUndo()
    let old_undolevels = &undolevels
    set undolevels=-1
    exe "normal a \<BS>\<Esc>"
    let &undolevels = old_undolevels
    unlet old_undolevels
endfunction
command! -nargs=0 ClearUndo call <SID>ForgetUndo()
" }}}

" QuickRun {{{
if neobundle#is_installed('quickrun')
let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
      \ 'type' : 'markdown/pandoc',
      \ 'outputter': 'browser',
      \ 'args' : '-f markdown+definition_lists --standalone --mathjax'
      \ }
endif
" }}}

" Vim-fugitive {{{
nnoremap [git] <Nop>
nmap [start]g [git]

nnoremap [git]m :<C-u>Gmove 
nnoremap [git]r :<C-u>Gread
nnoremap [git]C :<C-u>Gcommit -am ""<LEFT>
nnoremap <silent> [git]a :<C-u>Gwrite<CR>
nnoremap <silent> [git]c :<C-u>Gcommit<CR>
nnoremap <silent> [git]d :<C-u>Gdiff<CR>
nnoremap <silent> [git]l :<C-u>Glog<CR>
nnoremap <silent> [git]p :<C-u>Gpush<CR>
nnoremap <silent> [git]s :<C-u>Gstatus<CR>
nnoremap <silent> [git]bl :<C-u>Gblame<CR>
nnoremap <silent> [git]br :<C-u>Gbrowse<CR>
" }}}

" Local config {{{
if filereadable($HOME."/.vimrc.local")
    so $HOME/.vimrc.local"
endif
" }}}

" vim: foldmethod=marker
