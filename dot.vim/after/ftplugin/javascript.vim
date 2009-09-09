" don't insert comment leader automatically
setlocal formatoptions-=ro

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=0

nnoremap <buffer> ,f i(function() {<CR><CR>})();<C-o>k<Tab>
inoremap <buffer> ,f (function() {<CR><CR>})();<C-o>k<Tab>

" for errormarker.vim

" -w: warning on
" -s strict on
" -C compile only
"setlocal makeprg=smjs\ -wsC\ %
"setlocal errorformat=%f:%l:%m

" for javascript lint
setlocal makeprg=jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
setlocal errorformat=%f(%l):\ %m

au BufWritePost <buffer> silent make

if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
endif

let b:undo_ftplugin .= '
\ | setlocal formatoptions<
\ | setlocal tabstop<
\ | setlocal shiftwidth<
\ | setlocal softtabstop<
\ | setlocal makeprg<
\ | setlocal errorformat<
\ | execute "nunmap <buffer> ,f"
\ | execute "iunmap <buffer> ,f"
\'

