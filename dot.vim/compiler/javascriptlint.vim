if exists("current_compiler")
    finish
endif

let current_compiler = "javascriptlint"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" nodelint -- Run JSLint from the command-line under node.js
" npm install nodelint
CompilerSet makeprg=nodelint\ --config\ ~/.vim/compiler/nodelintconfig.js\ %
CompilerSet errorformat=%A%f\\,\ line\ %l\\,\ character\ %c:%m,%C%.%#,%Z%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

