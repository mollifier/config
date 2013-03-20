if exists("current_compiler")
    finish
endif

let current_compiler = "jshint"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" jshint -- Static analysis tool for JavaScript
" npm install -g jshint
CompilerSet makeprg=jshint\ --config\ ~/.vim/compiler/jshintrc\ %
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%+Z%p^,%+C%.%#,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save

