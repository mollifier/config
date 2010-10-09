" Folding setting for diff.
" Version: 0.1.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

setlocal foldmethod=expr foldexpr=DiffFold(v:lnum)

function! DiffFold(lnum)
  let line = getline(a:lnum)
  let next = getline(a:lnum + 1)
  if line =~ '^[-=]\{3}'
    return 1
  elseif next =~ '^[-=]\{3}'
    return '<1'
  elseif line =~ '^@@'
    return 2
  elseif next =~ '^@@'
    return '<2'
  endif
  return '='
endfunction


if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl fdm< fde<'
