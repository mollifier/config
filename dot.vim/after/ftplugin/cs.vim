" don't insert comment leader automatically
setlocal formatoptions-=ro

setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=0

setlocal expandtab

if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
endif

let b:undo_ftplugin .= '
\ | setlocal formatoptions<
\ | setlocal tabstop<
\ | setlocal shiftwidth<
\ | setlocal softtabstop<
\ | setlocal expandtab<
\'

