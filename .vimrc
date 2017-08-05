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
let g:solarized_termtrans=1
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized
" }}}

" Power Line {{{
"powerlineで矢印を使う iTremでfontはpowerline用の物を指定
set laststatus=2
set rtp+=~/.cache/dein/repos/github.com/Lokaltog/powerline/powerline/bindings/vim
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
autocmd FileType python setl textwidth=79
autocmd FileType python setl formatoptions+=tcqw
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

" Key Bindings & Shortcuts for Normal Mode {{{
nnoremap [start] <Nop>
nmap ; [start]

nnoremap j gj
nnoremap k gk

nnoremap <Space>d :<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>kdd
nnoremap <Space>l O<ESC>78i-<ESC>
nnoremap .r :<C-u>source ~/dotfiles/.vimrc<CR>
nnoremap <silent> .e :<C-u>edit ~/dotfiles/.vimrc<CR><CR>
" あまりに押し間違いが多いので．
nnoremap q: :<C-u>

nnoremap [start]n :<C-u>set nonumber!<CR>

nnoremap [start]r :<C-u>QuickRun<CR>
" tagsジャンプの際に複数ある場合を考慮
nnoremap [start]g <C-]>
nnoremap [start]t :TagbarToggle<CR>

nnoremap <silent> <C-b>D :bd!<CR>
nnoremap <silent> <C-b>d :bd<CR>
nnoremap <silent> <C-w>n :enew<CR>

nnoremap <silent> tc :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabedit<CR>
nnoremap <silent> ts :<C-u>tab sp<CR>

nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0zz' : 'l'
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zczz' : 'h'
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

" Unite {{{
" 入力モードで開始
let g:unite_enable_start_insert=1

" カレントディレクトリ
nnoremap <silent> [start]o :<C-u>UniteWithBufferDir file file/new<CR>

" カレントディレクトリ・プレビューモード
nnoremap <silent> [start]pv :<C-u>UniteWithBufferDir file_rec:! -auto-preview
            \ -no-split -vertical-preview<CR> 

" プロジェクト全表示＆検索
nnoremap <silent> <C-p> :<C-u>UniteWithProjectDir -start-insert file_rec/async:! file/new<CR>
let g:unite_source_rec_max_cache_files = 20000

" バッファ
nnoremap <silent> [start]b :<C-u>Unite buffer<CR>

" ヒストリ
nnoremap <silent> [start]h :<C-u>Unite file_mru<CR>

" ブックマーク
nnoremap <silent> [start]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [start]a :<C-u>UniteBookmarkAdd<CR>

" ヤンクヒストリ
nnoremap <silent> [start]y :<C-u>Unite history/yank<CR>

autocmd FileType unite call s:unite_my_settings()

function! s:unite_my_settings()"{{{
    "ESCでuniteを終了
    nnoremap <silent> <buffer> <Esc><Esc> :q<CR>
    inoremap <silent> <buffer> <Esc><Esc> <Esc>:q<CR>
    inoremap <buffer> <C-a> <Home>
    inoremap <buffer> <C-e> <End>
    inoremap <buffer> <C-b> <Left>
    inoremap <buffer> <C-f> <Right>
    inoremap <buffer> <C-n> <Down>
    inoremap <buffer> <C-p> <UP>
    inoremap <buffer> <C-h> <BS>
    "ctrl+sで縦に分割して開く
    nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
    inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
    "ctrl+vで横に分割して開く
    nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
endfunction" }}}
let g:unite_source_history_yank_enable =1
" }}}

" NeoComplete{{{
" if neobundle#is_sourced('neocomplete.vim')
"     " Disable AutoComplPop.
"     let g:acp_enableAtStartup = 0
"     " Use neocomplete.
"     let g:neocomplete#enable_at_startup = 1
"     " Use smartcase.
"     let g:neocomplete#enable_smart_case = 1
"     " Set minimum syntax keyword length.
"     let g:neocomplete#sources#syntax#min_keyword_length = 3
"     let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" 
"     " Define dictionary.
"     let g:neocomplete#sources#dictionary#dictionaries = {
"                 \ 'default' : '',
"                 \ 'vimshell' : $HOME.'/.vimshell_hist',
"                 \ 'scheme' : $HOME.'/.gosh_completions'
"                 \ }
"     " Define keyword.
"     if !exists('g:neocomplete#keyword_patterns')
"         let g:neocomplete#keyword_patterns = {}
"     endif
"     let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" 
"     " Plugin key-mappings.
"     inoremap <expr><C-g>     neocomplete#undo_completion()
"     inoremap <expr><C-l>     neocomplete#complete_common_string()
" 
"     " Recommended key-mappings.
"     " <CR>: close popup and save indent.
"     inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"     function! s:my_cr_function()
"         return neocomplete#close_popup() . "\<CR>"
"         " For no inserting <CR> key.
"         "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
"     endfunction
"     " <TAB>: completion.
"     inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"     " <C-h>, <BS>: close popup and delete backword char.
"     inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"     inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"     inoremap <expr><C-y>  neocomplete#close_popup()
"     " inoremap <expr><C-e>  neocomplete#cancel_popup()
"     " Close popup by <Space>.
"     inoremap <expr><Space> pumvisible() ? neocomplete#close_popup()."\<Space>" : "\<Space>"
"     
" 
" 
"     " For cursor moving in insert mode(Not recommended)
"     "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"     "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"     "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"     "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
"     " Or set this.
"     "let g:neocomplete#enable_cursor_hold_i = 1
"     " Or set this.
"     "let g:neocomplete#enable_insert_char_pre = 1
" 
"     " AutoComplPop like behavior.
"     "let g:neocomplete#enable_auto_select = 1
" 
"     " Shell like behavior(not recommended).
"     "set completeopt+=longest
"     "let g:neocomplete#enable_auto_select = 1
"     "let g:neocomplete#disable_auto_complete = 1
"     "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
" 
"     " Enable omni completion.
"     " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"     " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"     " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"     " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"     " autocmd FileType python setlocal omnifunc=
"     " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" 
"     " Enable heavy omni completion.
"     " if !exists('g:neocomplete#sources#omni#input_patterns')
"     "     let g:neocomplete#sources#omni#input_patterns = {}
"     " endif
"     "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"     "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"     "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" 
"     " For perlomni.vim setting.
"     " https://github.com/c9s/perlomni.vim
"     " let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" endif
" }}}

" VimShell {{{
nnoremap <silent> [start]s :<C-u>VimShellPop<CR>
nnoremap <silent> [start]S :<C-u>VimShellTab<CR>
let g:vimshell_right_prompt = 'GetGitDetail()'
let g:vimshell_user_prompt = 'getcwd()'
let g:vimshell_enable_start_insert = 0

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

" ctags {{{
let g:auto_ctags = 0
let g:auto_ctags_directory_list = ['.git', '.']
let g:auto_ctags_tags_args = '-R --tag-relative --recurse --sort=yes'
" let g:auto_ctags_tags_args = '-R --tag-relative --recurse --sort=yes $VIRTUAL_ENV/lib/'
" }}}

" Clear undo history {{{
" A function to clear the undo history
" function! <SID>ForgetUndo()
"     let old_undolevels = &undolevels
"     set undolevels=-1
"     exe "normal a \<BS>\<Esc>"
"     let &undolevels = old_undolevels
"     unlet old_undolevels
" endfunction
" command! -nargs=0 ClearUndo call <SID>ForgetUndo()
" }}}

" QuickRun {{{
" if neobundle#is_installed('vim-quickrun')
"     let g:quickrun_config = {}
"     let g:quickrun_config.python = {'command' : 'python3'}
"     let g:quickrun_config._ = {'outputter/buffer/close_on_empty' : 1}
" 
"     let g:quickrun_config.markdown = {
"                 \ 'type' : 'markdown/gfm',
"                 \ 'outputter': 'browser'
"                 \ }
"     " let g:quickrun_config.markdown = {
"     "             \ 'outputter': 'browser',
"     "             \ 'args': '--mathjax'
"     "             \ }
" 
"     if neobundle#is_installed('vimproc')
"         let g:quickrun_config._ = {'runner' : 'vimproc'}
"     endif
" endif
" }}}

" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
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

" open-browser-github.vim{{{
nnoremap <silent> [start]go :<C-u>OpenGithubProject<CR>
" }}}

" vimfiler {{{ 
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
" Like Textmate icons.
let g:vimfiler_tree_leaf_icon = ' '
if has('gui_running')
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
else
    let g:vimfiler_tree_opened_icon = 'V'
    let g:vimfiler_tree_closed_icon = '>'
endif
let g:vimfiler_file_icon = '-'
nnoremap <silent> [start]e :<C-u>VimFilerCurrentDir -buffer-name=explorer 
            \ -split -simple -winwidth=35 -toggle -no-quit<CR>
autocmd VimEnter * if !argc() | VimFilerCurrentDir -buffer-name=explorer 
            \ -split -simple -winwidth=35 -toggle -no-quit | endif
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

" Local config {{{
if filereadable($HOME."/.vimrc.local")
    so $HOME/.vimrc.local"
endif
" }}}

" vim: foldmethod=marker
