" don't insert comment leader automatically
setlocal formatoptions-=ro

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

