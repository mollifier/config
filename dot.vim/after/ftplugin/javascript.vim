" don't insert comment leader automatically
setlocal formatoptions-=ro

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=0

compiler jshint
"au BufWritePost <buffer> silent make

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
\'

