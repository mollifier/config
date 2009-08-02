" don't insert comment leader automatically
setlocal formatoptions-=ro

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

