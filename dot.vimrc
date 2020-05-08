" vimrc

" Remove ALL autocommands for the current group.
autocmd!

" vim-plug
if filereadable($HOME . '/.vimplug.vim')
    source $HOME/.vimplug.vim
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
set display=lastline

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

" vim-wordcount "{{{
" https://github.com/fuenor/vim-wordcount
"
" set statusline+=[wc:%{WordCount()}]
" set updatetime=500
"
" :call WordCount('char') " count char
" :call WordCount('byte') " count byte
" :call WordCount('word') " count word

augroup WordCount
  autocmd!
  autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END

let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
  if a:0 == 0
    return s:WordCountStr
  endif
  let cidx = 3
  silent! let cidx = s:WordCountDict[a:1]

  let s:WordCountStr = ''
  let s:saved_status = v:statusmsg
  exec "silent normal! g\<c-g>"
  if v:statusmsg !~ '^--'
    let str = ''
    silent! let str = split(v:statusmsg, ';')[cidx]
    let cur = str2nr(matchstr(str, '\d\+'))
    let end = str2nr(matchstr(str, '\d\+\s*$'))
    if a:1 == 'char'
      let cr = &ff == 'dos' ? 2 : 1
      let cur -= cr * (line('.') - 1)
      let end -= cr * line('$')
    endif
    let s:WordCountStr = printf('%d/%d', cur, end)
  endif
  let v:statusmsg = s:saved_status
  return s:WordCountStr
endfunction

function! LineCharCount(...)
  return strchars(getline('.'))
endfunction



" Statusline  "{{{1
set laststatus=2    "always show statusline
let &statusline = '[%n] %f %m %r%{&foldenable!=0?"[fen]":""}%=[Col:%c%V/%{LineCharCount()}] [L:%l/%L] [C:%{WordCount()}] (%p%%) %{"[".(&fenc!=""?&fenc:&enc)."][".&ff."]"}'
set updatetime=500


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
vnoremap * "zy:let @/ = @z<CR>n
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

" markdown
let g:markdown_fenced_languages = [
\  'sh',
\  'zsh',
\  'css',
\  'erb=eruby',
\  'javascript',
\  'js=javascript',
\  'json=javascript',
\  'ruby',
\  'sass',
\  'xml',
\]

let g:vim_markdown_initial_foldlevel=10

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

set fileencodings=utf-8,cp932,euc-jp,default,latin
set encoding=utf-8

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
noremap gS J

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
let g:eregex_default_enable = 0
nnoremap ,/ :<C-u>M/
nnoremap <SPACE>/ :<C-u>M/

" closetag.vim "{{{2
if filereadable($HOME . '/.vim/scripts/closetag.vim')
    au Filetype html,xml,xsl source $HOME/.vim/scripts/closetag.vim
endif

" quickrun "{{{2
nnoremap <silent> <SPACE>x :QuickRun -mode n<CR>
vnoremap <silent> <SPACE>x :QuickRun -mode v<CR>

" ctrlp "{{{2
" type <SPACE>P to invoked ctrlp buffer
let g:ctrlp_map = '<SPACE>p'

" for Fugitive "{{{2
" Vim plugin for Git
nnoremap <Space>gd :<C-u>Gdiff<Enter>
nnoremap <Space>gs :<C-u>Gstatus<Enter>
nnoremap <Space>gl :<C-u>Glog<Enter>
nnoremap <Space>ga :<C-u>Gwrite<Enter>
nnoremap <Space>gc :<C-u>Gcommit<Enter>
nnoremap <Space>gb :<C-u>Gblame<Enter>

" for syntastic "{{{2
let g:syntastic_always_populate_loc_list = 1
" use :lopen
"let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Source local rc file"{{{1
if filereadable($HOME . '/.vimrc_local')
    source $HOME/.vimrc_local
elseif filereadable($HOME . '/_vimrc_local')
    source $HOME/_vimrc_local
endif

" vim:set ft=vim ts=4 sw=4 sts=0 foldmethod=marker:
