" don't insert comment leader automatically
setlocal formatoptions-=ro

setlocal expandtab

if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
endif

let b:undo_ftplugin .= '
\ | setlocal formatoptions<
\ | setlocal expandtab<
\'

