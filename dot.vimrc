" vimrc

" Remove ALL autocommands for the current group.
autocmd!

" neobundle.vim
if filereadable($HOME . '/.neobundles.vim')
    source $HOME/.neobundles.vim
elseif filereadable($HOME . '/_neobundles.vim')
    source $HOME/_neobundles.vim
endif


" Basic  "{{{1
language C
set nocompatible
set number
set showmode
set showcmd
set wildmode=list:longest,full
set backspace=0     "same as vi
set textwidth=0     "don't breake line however long it is
set nrformats-=octal    "don't use octal number
set history=50
let g:netrw_alto=1
set completeopt=menuone,preview

set modeline
set modelines=5

set showmatch       "jump to the matching bracket
set matchtime=1     "1/10sec time scale
set matchpairs+=<:>
let loaded_matchparen = 1

" don't enable IM when entering Insert/Search mode
set iminsert=0
set imsearch=0

set virtualedit+=block " Allow virtual editing in Visual block mode.

" no beep
set vb t_vb=

set nolist        "show non-printing character
set listchars=tab:>\ 

set tags+=./tags;

if has('unix')
    set nofsync
    set swapsync=
endif

" Autocmd  "{{{1
" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif

" Highlight the cursorline in insert mode
augroup InsertHook
    autocmd!
    autocmd InsertEnter * setlocal cursorline
    autocmd InsertLeave * setlocal nocursorline
augroup END


" Utilities  "{{{1
"invert scroll bind for all windows
function! InvertScrollBindAll()
    if &scrollbind
        windo set noscrollbind
        echo "disable scrollbind"
    else
        windo set scrollbind
        echo "enable scrollbind"
    endif
endfunction

"invert number and list options
function! InvertList()
    if &number || &list
        setlocal nonumber
        setlocal nolist
        setlocal foldcolumn=0
    else
        setlocal number
        setlocal list
        setlocal foldcolumn=3
    endif
endfunction

"code conversion functions
function! ToUtf8()
    setlocal fileencoding=utf-8
    setlocal fileformat=unix
endfunction

function! ToShiftJis()
    setlocal fileencoding=cp932
    setlocal fileformat=dos
endfunction

function! ToEucJp()
    setlocal fileencoding=euc-jp
    setlocal fileformat=unix
endfunction

"convert into HTML entity reference
function! ConvertToHTMLEntityRef()
    let s:line = getline(".")
    let s:repl = substitute(s:line, '&', '\&amp;', "g")
    let s:repl = substitute(s:repl, '<', '\&lt;', "g")
    let s:repl = substitute(s:repl, '>', '\&gt;', "g")
    let s:repl = substitute(s:repl, '"', '\&quot;', "g")
    call setline(".", s:repl)
endfunction

function! Presentation()
    set laststatus=0    " never show statusline
    set nonumber
    set nolist
    set foldcolumn=0
endfunction

function! Navi() "{{{
  if &ft ==? "c" || &ft ==? "cpp"
    vimgrep /^[^ \t#/\\*]\+[0-9A-Za-z_ :\t\\*]\+([^;]*$/j %
  elseif &ft ==? "perl"
    vimgrep /^\s*sub\s/j %
  elseif &ft ==? "ruby"
    vimgrep /^\s*\(class\|module\|def\|alias\)\s/j %
  elseif &ft ==? "python"
    vimgrep /^\s*\(class\|def\)\s/j %
  elseif &ft ==? "javascript"
    vimgrep /^\s*function\s\|[a-zA-Z_$][a-zA-Z0-9_$]*\s*[=:]\s*function\s*(/j %
  elseif &ft ==? "sh"
    vimgrep /^\s*\(\h\w*\s*()\|function\s\+\h\w*\)/j %
  elseif &ft ==? "html"
    vimgrep /\c^\s*\(<h[1-6]\|<head\|<body\|<form\)/j %
  elseif &ft ==? ""
    "Text ( 1. 2. ,etc )
    vimgrep /^\s*\d\+\./j %
  elseif &ft ==? "java"
    vimgrep /^\s*[^#/\*=]\+[0-9a-zA-Z_ \t\*,.()]\+{[^;]*$/j %
  elseif &ft ==? "diff"
    "diff (unified format)
    vimgrep /^@@[0-9 \t,+-]\+@@$/j %
  else
    echo "This filetype is not supported."
  endif
  cw
endfunction "}}}

function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)


" Statusline  "{{{1
set laststatus=2    "always show statusline
let &statusline = '[%n] %f %m %r%{&foldenable!=0?"[fen]":""}%=%l/%L (%p%%) %{"[".(&fenc!=""?&fenc:&enc)."][".&ff."]"}'


" Indent  "{{{1
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set autoindent
filetype plugin indent on


" Backup  "{{{1
set backup
set backupcopy=yes
set backupdir=$HOME/.backup/vi,.


" Search  "{{{1
set hlsearch
set incsearch

"search highlighted word in visual mode
vnoremap * y/<C-R>0<CR>
vnoremap # y?<C-R>0<CR>

"clear hlsearch
nnoremap <SPACE>c :<C-u>nohlsearch<CR>

" Color  "{{{1

set t_Co=16
"set background=light
set background=dark

syntax enable
"syntax off

colorscheme mrkn256
"colorscheme lucius
"colorscheme molokai
"colorscheme jellybeans
"colorscheme wombat256mod

"Tab
highlight SpecialKey ctermfg=Grey
"End of line
highlight NonText ctermfg=Grey
"Search pattern
highlight Search term=reverse ctermfg=White ctermbg=Blue

" Popup Menu
hi Pmenu cterm=NONE ctermfg=Black ctermbg=White
hi PmenuSel cterm=underline,bold ctermfg=White ctermbg=DarkBlue
hi PmenuSbar term=NONE cterm=NONE
hi PmenuThumb term=reverse cterm=reverse


" show invisible characters "{{{2
if has('autocmd') && has('syntax')
    syntax on
    function! ShowInvisibleCharacters()
        " double width space
        syntax match DoubleWidthSpace "\%u3000" display containedin=ALL
        " trailing whitespace characters
        syntax match TrailingWhitespace "\s\+$" display containedin=ALL
 
        " these are performed as error
        highlight default link DoubleWidthSpace Error
        highlight default link TrailingWhitespace Error
    endfunction
 
    augroup showInvisible
        autocmd! showInvisible
        autocmd BufNew,BufRead * call ShowInvisibleCharacters()
    augroup END
endif


" Character and linefeed code "{{{1

"auto recognition (from zun wiki)
"linefeed code
set fileformats=unix,dos,mac

if exists('&ambiwidth')
    set ambiwidth=double
endif

"character code
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif

if has('iconv') "{{{
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'

    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        " iconv support eucJP-ms
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        " iconv suppot JISX0213
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif

    " set fileencodings
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif

    " unlet variables
    unlet s:enc_euc
    unlet s:enc_jis
endif "}}}

if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif


" Filetype  "{{{1
"sh
let is_bash=1

"zip
"see also :help zip-extension
au BufReadCmd *.jar,*.xpi call zip#Browse(expand("<amatch>"))

"Markdown
" disable * and _
autocmd! FileType markdown hi! def link markdownItalic Normal

" Fold  "{{{1
set foldmethod=expr
set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
set nofoldenable
set foldcolumn=3


" Map  "{{{1
"no effect keys
map s <Nop>
map <SPACE> <Nop>

"make CTRL-K an additional ESC
noremap <C-K> <ESC>
cnoremap <C-K> <C-C>
inoremap <C-K> <ESC>
snoremap <C-K> <ESC>

noremap Y y$
noremap gh ^
noremap gl $
noremap S gJ

"define tcsh style editing keys
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

"edit
onoremap <silent> q /["'{}()[\]<>]<CR>:nohlsearch<CR>
"insert the text which was deleted or yanked last time
inoremap <C-Z> <C-O>:set paste<CR><C-R>"<C-O>:set nopaste<CR>
"end completion and begin new line
inoremap <C-J> <C-E><CR>

" put text from register 0
" register 0 contains the text from the most recent yank command
vnoremap <silent> <C-p> "0p
nnoremap <silent> <C-p> "0P



"scroll
noremap J <C-D>
noremap K <C-U>

"jump
"exclusive motion
noremap sm `

"buffer operation
nnoremap sp :<C-u>bp<CR>
nnoremap sn :<C-u>bn<CR>

"window operation
"open and close
nnoremap ss <C-W>s
nnoremap sc <C-W>c
nnoremap so <C-W>o
"move
nnoremap sj <C-W>j
nnoremap sk <C-W>k
nnoremap <silent> sh <C-W>h:call <SID>good_width()<CR>
nnoremap <silent> sl <C-W>l:call <SID>good_width()<Cr>

function! s:good_width()
  if winwidth(0) < 84
    vertical resize 84
  endif
endfunction

"resize
nnoremap + <C-W>+
nnoremap - <C-W>-
nnoremap ) <C-W>>
nnoremap ( <C-W><LT>

function! s:big()
    wincmd _ | wincmd |
endfunction
nnoremap <silent> s<CR> :<C-u>call <SID>big()<CR>

nnoremap s0 1<C-W>_
nnoremap s. <C-W>=


nnoremap <Space>w :<C-u>update<CR>:<C-u>echo ""<CR>
nnoremap <Space>q :<C-u>qall<CR>

nnoremap <C-h> :<C-u>help<Space>

nnoremap <Space>m :<C-u>make<CR>

"move to next/previous line with same indentation
nnoremap <silent> <SPACE>kk k:<C-u>call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
nnoremap <silent> <SPACE>jj :<C-u>call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^

"call function
"invert scrollbind
nnoremap sb :<C-u>call InvertScrollBindAll()<CR>
"navi
nnoremap <SPACE>v :<C-u>call Navi()<CR>
nnoremap go :<C-u>copen<CR>
nnoremap gc :<C-u>cclose<CR>
nnoremap <SPACE>n :<C-u>cnext<CR>
nnoremap <SPACE>p :<C-u>cprevious<CR>

"invert number and list options
nnoremap <silent> sv :<C-u>call InvertList()<CR>

" format json
" require python 2.6 or later
vnoremap <Space>json !python -m json.tool<CR>
nnoremap <Space>json :<C-u>% !python -m json.tool<CR>


" For plugins "{{{1
" NERD_tree "{{{2
nnoremap sd :<C-u>NERDTreeToggle<CR>

" eregex "{{{2
nnoremap / :<C-u>M/
nnoremap ,/ /

" closetag.vim "{{{2
if filereadable($HOME . '/.vim/scripts/closetag.vim')
    au Filetype html,xml,xsl source $HOME/.vim/scripts/closetag.vim
endif

" surround.vim "{{{2
"see also :help surround-mappings Note
"remove surround mappings in visual mode
vmap <Leader>s <Plug>Vsurround
vmap <Leader>S <Plug>VSurround

" xul.vim (Syntax for XUL) "{{{2
let xul_noclose_script = 1

" hatena.vim (Syntax for hatena) "{{{2
let g:hatena_syntax_html = 1

" teramako/jscomplete-vim  "{{{2
let g:jscomplete_use = ['dom']

" neocomplcache "{{{2
" Disable AutoComplPop.
"let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" 'p_h' -> 'p*_h*'
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3

let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup()."\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
" accept completion
inoremap <expr><C-y>  neocomplcache#close_popup()
" cancel completion
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:neocomplcache_source_rank = {
  \ 'jscomplete' : 500,
  \ }

" Define dictionary.
let g:NeoComplCache_DictionaryFileTypeLists = {
            \ 'default' : '',
            \ 'scala' : $HOME . '/.vim/dict/scala.dict'
            \ }

" neosnippet "{{{2
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" User defined snippet directory
let g:neosnippet#snippets_directory='$HOME/.vim/snippets/,$HOME/vimfiles/snippets/'


" unite.vim "{{{2
" start in insert mode
let g:unite_enable_start_insert = 1

" unite startup mappings "{{{3
nnoremap <silent> <SPACE>b :<C-u>Unite buffer<CR>
"nnoremap <silent> <SPACE>f :<C-u>Unite file_rec<CR>
" file_rec/async requires vimproc
nnoremap <silent> <SPACE>f :<C-u>Unite file_rec/async<CR>
nnoremap <silent> <SPACE>r :<C-u>Unite file_mru<CR>

" mappings in unite buffer "{{{3
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
    nmap <buffer> <ESC> <Plug>(unite_exit)
    nmap <buffer> <C-K> <Plug>(unite_exit)
    imap <buffer> <C-W> <Plug>(unite_delete_backward_path)

    " use <SPACE>x instead of <SPACE>
    nmap <buffer> <SPACE>x <Plug>(unite_toggle_mark_current_candidate)
    imap <buffer> <SPACE>x <Plug>(unite_toggle_mark_current_candidate)
    vmap <buffer> <SPACE>x <Plug>(unite_toggle_selected_candidates)
endfunction

" unite-outline "{{{2
nnoremap <silent> <SPACE>uo :<C-u>Unite outline<CR>

" vim-jsdoc "{{{2
let g:jsdoc_default_mapping = 0
nnoremap <silent> <SPACE>jd :JsDoc<CR>

" quickrun "{{{2
nnoremap <silent> <SPACE>x :QuickRun -mode n<CR>
vnoremap <silent> <SPACE>x :QuickRun -mode v<CR>

" ctrlp "{{{2
let g:ctrlp_map = '<SPACE>p'

" unite-rails "{{{2
nnoremap <silent> <SPACE>rm :<C-u>Unite rails/model<CR>
nnoremap <silent> <SPACE>rc :<C-u>Unite rails/controller<CR>
nnoremap <silent> <SPACE>rv :<C-u>Unite rails/view<CR>
nnoremap <silent> <SPACE>rt :<C-u>Unite rails/spec<CR>

" rails.vim "{{{2
nnoremap <silent> <SPACE>rr :<C-u>R<CR>
nnoremap <silent> <SPACE>rs :<C-u>RS<CR>
nnoremap <silent> <SPACE>ra :<C-u>A<CR>


" Source local rc file"{{{1
if filereadable($HOME . '/.vimrc_local')
    source $HOME/.vimrc_local
elseif filereadable($HOME . '/_vimrc_local')
    source $HOME/_vimrc_local
endif

" vim:set ft=vim ts=4 sw=4 sts=0 foldmethod=marker:
