" vimrc

" Remove ALL autocommands for the current group.
autocmd!

" for fish shell user
" Vim needs a more POSIX compatible shell
if &shell =~# 'fish$'
    set shell=sh
endif

" vim-polyglot "{{{2
let g:polyglot_disabled = ['csv']

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
set cursorline
set display=lastline
" always show column. for vim-gitgutter
set signcolumn=yes

let mapleader = "\<Space>"

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

" Undo persistence
if has('persistent_undo')
    " need mkdir
    " mkdir -p $HOME/.local/share/vim/undo
    set undodir=$HOME/.local/share/vim/undo
    set undofile
endif

" Autocmd  "{{{1
" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif

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
        setlocal signcolumn=no
    else
        setlocal number
        setlocal list
        setlocal signcolumn=yes
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
endfunction

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
let g:lightline = {
    \ 'colorscheme': 'iceberg',
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \ }
    \ }

function! LightlineFilename()
	" Reduce file name to be relative to current directory
    return expand("%:~:.")
endfunction

" Indent  "{{{1
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set autoindent
filetype plugin on
filetype indent on


" Backup  "{{{1
set backup
set backupcopy=yes
" need mkdir
" mkdir -p $HOME/.local/share/vim/backup
set backupdir=$HOME/.local/share/vim/backup

" swap file path  "{{{1
set directory=.,$HOME/tmp,/var/tmp,/tmp

" Search  "{{{1
set hlsearch
set incsearch

"search highlighted word in visual mode
vnoremap * "zy:let @/ = @z<CR>n
vnoremap # y?<C-R>0<CR>

"clear hlsearch
nnoremap <Leader>c :<C-u>nohlsearch<CR>

" Color  "{{{1

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
syntax on
set termguicolors

"set background=light
set background=dark

"colorscheme onedark
"colorscheme nord
"colorscheme mrkn256
"colorscheme lucius
"colorscheme molokai
"colorscheme jellybeans
"colorscheme wombat256mod
"colorscheme nightfox
" colorscheme duskfox
colorscheme iceberg

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

set fileencodings=ucs-bom,utf-8,cp932,latin1
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

" Map  "{{{1
"no effect keys
map s <Nop>
xmap s <Nop>

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


nnoremap <Leader>w :<C-u>update<CR>:<C-u>echo ""<CR>
nnoremap <Leader>q :<C-u>qall<CR>

nnoremap <C-h> :<C-u>help<Space>

nnoremap <Leader>m :<C-u>make<CR>

"move to next/previous line with same indentation
nnoremap <silent> <Leader>kk k:<C-u>call search ("^". matchstr (getline (line (".")+ 1), '\(\s*\)') ."\\S", 'b')<CR>^
nnoremap <silent> <Leader>jj :<C-u>call search ("^". matchstr (getline (line (".")), '\(\s*\)') ."\\S")<CR>^

"call function
"invert scrollbind
nnoremap sb :<C-u>call InvertScrollBindAll()<CR>
nnoremap <Leader>n :<C-u>cnext<CR>
nnoremap <Leader>p :<C-u>cprevious<CR>

"invert number and list options
nnoremap <silent> sv :<C-u>call InvertList()<CR>

" format json
" require python 2.6 or later
vnoremap <Leader>json !python -m json.tool<CR>
nnoremap <Leader>json :<C-u>% !python -m json.tool<CR>

" grep
" :grep <WORD>
" :copen or :cope to open quickfix window
" :cwindow or :cw to open quickfix window
" :cclose or :ccl to close quickfix window
" require ripgrep
" https://github.com/BurntSushi/ripgrep
if executable('rg')
  let &grepprg = 'rg --vimgrep --smart-case --hidden'
  set grepformat=%f:%l:%c:%m
endif
" open quickfix window automatically
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen

"function! s:grep(word) abort
"  :grep a:word | copen
"endfunction
"
"command! -nargs=1 Grep call <SID>grep(<q-args>)

" For plugins "{{{1

" vim-gitgutter "{{{2
" disable gitgutter mappings
let g:gitgutter_map_keys = 0
" Update signs for all buffers
nnoremap <Leader>lc :<C-u>GitGutterAll<CR>

" ddc.vim "{{{2
" Customize global settings

" You must set the default ui.
" NOTE: native ui
" https://github.com/Shougo/ddc-ui-native
call ddc#custom#patch_global('ui', 'native')

" 'Shougo/ddc-source-around'
" 'shun/ddc-source-vim-lsp'
" 'LumaKernel/ddc-source-file'
call ddc#custom#patch_global('sources', ['around', 'vim-lsp',  'file'])

" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
" 'Shougo/ddc-filter-converter_remove_overlap'
call ddc#custom#patch_global('sourceOptions', #{
      \   _: #{
      \     matchers: ['matcher_head'],
      \     sorters: ['sorter_rank'],
      \     converters: ['converter_remove_overlap']
      \   },
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', #{
      \   around: #{ mark: 'A' },
      \ })
call ddc#custom#patch_global('sourceParams', #{
      \   around: #{ maxSize: 500 },
      \ })

" 'shun/ddc-source-vim-lsp'
call ddc#custom#patch_global('sourceOptions', #{
    \   vim-lsp: #{
    \     matchers: ['matcher_head'],
    \     mark: 'lsp',
    \   },
    \ })

" 'LumaKernel/ddc-source-file'
call ddc#custom#patch_global('sourceOptions', {
    \ 'file': {
    \   'mark': 'F',
    \   'isVolatile': v:true,
    \   'forceCompletionPattern': '\S/\S*',
    \ }})
call ddc#custom#patch_filetype(
    \ ['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
    \   'file': {
    \     'forceCompletionPattern': '\S\\\S*',
    \   },
    \ },
    \ 'sourceParams': {
    \   'file': {
    \     'mode': 'win32',
    \   },
    \ }})

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources',
      \ ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', #{
      \   clangd: #{ mark: 'C' },
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
      \   around: #{ maxSize: 100 },
      \ })

" Mappings

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()

" fern.vim "{{{2
nnoremap so :<C-u>:Fern . -drawer -toggle<CR>

function! s:init_fern() abort
    setlocal nonumber
    setlocal nolist

    nmap <buffer> ge <Plug>(fern-action-open:edit)<C-w>p
    nmap <buffer> gl <Plug>(fern-action-open:edit)<C-w>p
    nmap <buffer> s <Plug>(fern-action-open:split)
    nmap <buffer> <C-x> <Plug>(fern-action-open:split)
    nmap <buffer> gs <Plug>(fern-action-open:split)<C-w>p
    nmap <buffer> g<C-x> <Plug>(fern-action-open:split)<C-w>p
    nmap <buffer> r <Plug>(fern-action-reload:all)

    " yuki-yano/fern-preview.vim
    nmap <silent> <buffer> p <Plug>(fern-action-preview:toggle)
    nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:toggle)
    nmap <silent> <buffer> <ESC> <Plug>(fern-action-preview:close)
    nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
    nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

" closetag.vim "{{{2
if filereadable($HOME . '/.vim/scripts/closetag.vim')
    au Filetype html,xml,xsl source $HOME/.vim/scripts/closetag.vim
endif

" fzf.vim "{{{2
" https://github.com/sharkdp/fd
let $FZF_DEFAULT_COMMAND='fd'
nnoremap <Leader>b :<C-u>Buffers<CR>
nnoremap <Leader>f :<C-u>Files<CR>
" v:oldfiles and open buffers
nnoremap <Leader>r :<C-u>History<CR>
" list directory
command! -bang -nargs=? -complete=dir FzfDirectories
            \ call fzf#vim#files(<q-args>, {'source': 'fd --type=directory', 'options': ['--preview', 'ls -- {}']}, <bang>0)
nnoremap <Leader>d :<C-u>FzfDirectories<CR>
" require ripgrep
" https://github.com/BurntSushi/ripgrep
nnoremap <Leader>g :<C-u>RG<CR>

" quickrun "{{{2
nnoremap <silent> <Leader>x :QuickRun -mode n<CR>
vnoremap <silent> <Leader>x :QuickRun -mode v<CR>

" vista.vim "{{{2
let g:vista_default_executive = 'vim_lsp'
nnoremap <Leader>vv :<C-u>Vista!!<CR>

" for CamelCaseMotion "{{{2
" ,w ,b ,e ,ge
let g:camelcasemotion_key = ','

" for ale "{{{2
nnoremap <Leader>lf :<C-u>ALEFix<Enter>

" for vim-lsp "{{{2
" Disable document diagnostics (e.g. warnings, errors)
" use ale
let g:lsp_diagnostics_enabled = 0
nnoremap <Leader>la :<C-u>LspCodeAction<Enter>
nnoremap <Leader>ld :<C-u>LspDefinition<Enter>

" onedark.vim "{{{2
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

" Source local rc file"{{{1
if filereadable($HOME . '/.vimrc_local')
    source $HOME/.vimrc_local
elseif filereadable($HOME . '/_vimrc_local')
    source $HOME/_vimrc_local
endif

" vim:set ft=vim ts=4 sw=4 sts=0 foldmethod=marker:
