" gvimrc

" Basic  "{{{1
"window size
set columns=97
set lines=34

"window positon
winpos 100 55

"font
set guifont=Monospace\ 14

"disable blink
set guicursor=a:blinkoff0


" Disable useless bars"{{{1
"toolbar
set guioptions-=T
"menuebar
set guioptions-=m
"scrollbar
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L


" Color  "{{{1
colorscheme denim
"colorscheme less
"colorscheme default

"fold color
hi Folded guibg=bg guifg=fg gui=NONE
hi FoldColumn guibg=bg guifg=fg gui=italic

"highlight zenkaku space
function! ZenkakuSpaceHighlight()
    syntax match ZenkakuSpace "　" display containedin=ALL
    highlight ZenkakuSpace guibg=LightCyan
endf

if has("syntax")
    syntax on
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ZenkakuSpaceHighlight()
    augroup END
endif

" Popup Menu
hi Pmenu guibg=#191919 guifg=#f5f5f5 gui=NONE
hi PmenuSel guibg=#f5f5f5 guifg=#191919 gui=NONE
hi PmenuSbar guibg=#808080 guifg=NONE gui=NONE
hi PmenuThumb guibg=#ffffff guifg=NONE gui=NONE


" Source local rc file"{{{1
if filereadable($HOME . '/.gvimrc_local')
    source $HOME/.gvimrc_local
elseif filereadable($HOME . '/_gvimrc_local')
    source $HOME/_gvimrc_local
endif


" vim:set ft=vim foldmethod=marker:
