" vimrc

" Remove ALL autocommands for the current group.
autocmd!

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


" Statusline  "{{{1
set laststatus=2    "always show statusline
set statusline=\ %f\ %m\ %r%{&foldenable!=0?'[fen]':''}%=%l/%L\ (%p%%)\ %{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}


" Indent  "{{{1
set tabstop=4
set shiftwidth=4
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

"invert highlight matching
function! InvertHlsearch()
    if &hlsearch
        set nohlsearch
        echo "disable hlsearch"
    else
        set hlsearch
        echo "enable hlsearch"
    endif
endfunction

"search highlighted word in visual mode
vnoremap * y/<C-R>0<CR>
vnoremap # y?<C-R>0<CR>


" Color  "{{{1

" enable 256 colors
set t_Co=256

set background=light
"set background=dark

syntax enable
"syntax off

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


"scroll
noremap J <C-D>
noremap K <C-U>

"jump
"exclusive motion
noremap sl `

"buffer operation
nnoremap sp :<C-u>bp<CR>
nnoremap sn :<C-u>bn<CR>

"window operation
"open and close
noremap ss <C-W>s
noremap sc <C-W>c
noremap so <C-W>o
"move
noremap sj <C-W>j
noremap sk <C-W>k
"resize
noremap + <C-W>+
noremap - <C-W>-
command! Big wincmd _ | wincmd |
noremap z<SPACE> :<C-u>Big<CR>
noremap z0 1<C-W>_
noremap z. <C-W>=

nnoremap <Space>w :<C-u>update<CR><C-l>
nnoremap <Space>q :<C-u>qall<CR>

nnoremap <C-h> :<C-u>help<Space>

nnoremap <Space>m :<C-u>make<CR>

"move to next/previous line with same indentation
nnoremap <silent> <SPACE>k k:<C-u>call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
nnoremap <silent> <SPACE>j :<C-u>call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^

" expand to full file path
cnoremap <C-X> <C-R>=expand('%:p')<CR>
" expand to dirrectory
cnoremap <C-Z> <C-R>=expand('%:p:h')<CR>/

"call function
"invert hlsearch
nnoremap <SPACE>c :<C-u>call InvertHlsearch()<CR>
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

"convert into HTML entity reference
nnoremap sh :<C-u>call ConvertToHTMLEntityRef()<CR>


" For plugins "{{{1
"NERD_tree
nnoremap sd :<C-u>NERDTreeToggle<CR>

"eregex
nnoremap / :<C-u>M/
nnoremap ,/ /

"closetag.vimg
if filereadable($HOME . '/.vim/scripts/closetag.vim')
    au Filetype html,xml,xsl source $HOME/.vim/scripts/closetag.vim
endif

"surround.vim
"see also :help surround-mappings Note
"remove surround mappings in visual mode
vmap <Leader>s <Plug>Vsurround
vmap <Leader>S <Plug>VSurround

"xul.vim (Syntax for XUL)
let xul_noclose_script = 1

"hatena.vim (Syntax for hatena)
let g:hatena_syntax_html = 1

" autocomplpop.vim JavaScript "{{{2
let g:AutoComplPop_Behavior={'javascript' : [
      \     {
      \       'command'  : "\<C-n>",
      \       'pattern'  : '\k\k$',
      \       'excluded' : '^$',
      \       'repeat'   : 0,
      \     },
      \     {
      \       'command'  : "\<C-x>\<C-f>",
      \       'pattern'  : (has('win32') || has('win64') ? '\f[/\\]\f*$' : '\f[/]\f*$'),
      \       'excluded' : '[*/\\][/\\]\f*$\|[^[:print:]]\f*$',
      \       'repeat'   : 1,
      \     },
      \     {
      \       'command'  : "\<C-x>\<C-o>",
      \       'pattern'  : '\([^. \t]\.\)$',
      \       'excluded' : '^$',
      \       'repeat'   : 0,
      \     },
      \   ]}

" fuzzyfinder.vim "{{{2
let g:fuf_ignoreCase = 1
let g:fuf_keyOpenVsplit = '<C-v>'
let g:fuf_file_exclude = '\v\.svn/$|\.git/$|\~$|\.o$|\.exe$|\.bak$|\.swp$|\.swo$|((^|[/\\])\.[/\\]$)'
let g:fuf_dir_exclude = '\v\.svn/$|\.git/$|((^|[/\\])\.{1,2}[/\\]$)'

nnoremap <silent> <SPACE>b :<C-u>FufBuffer<CR>
nnoremap <silent> <SPACE>f :<C-u>FufFile<CR>
nnoremap <silent> <SPACE>r :<C-u>FufMruFile<CR>
nnoremap <silent> <SPACE>d :<C-u>FufDir<CR>
nnoremap <silent> <SPACE>A :<C-u>FufAddBookmark<CR>
nnoremap <silent> <SPACE>B :<C-u>FufBookmark<CR>

" neocomplcache "{{{2
" Use not autocomplpop but neocomplcache
let g:acp_enableAtStartup = 0
let g:NeoComplCache_EnableAtStartup = 1
" Use not neocomplcache but autocomplpop
"let g:acp_enableAtStartup = 1
"let g:NeoComplCache_EnableAtStartup = 0

" quickrun "{{{2
nnoremap <silent> <SPACE>x :QuickRun -mode n<CR>
vnoremap <silent> <SPACE>x :QuickRun -mode v<CR>

" Source local rc file"{{{1
if filereadable($HOME . '/.vimrc_local')
    source $HOME/.vimrc_local
elseif filereadable($HOME . '/_vimrc_local')
    source $HOME/_vimrc_local
endif

" vim:set ft=vim foldmethod=marker:
