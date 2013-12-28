" neobundle.vim
" https://github.com/Shougo/neobundle.vim
"
" install neobundle
" % cd GIT_ROOT_DIR
" % git submodule add https://github.com/Shougo/neobundle.vim dot.vim/neobundle.vim.git
"
" install plugins from shell
" % vim -u ~/.neobundles.vim '+NeoBundleInstall' '+q'
"
" install
" :NeoBundleInstall
"
" install and update
" :NeoBundleInstall!
"
" update neobundle
" % cd dot.vim/neobundle.vim.git
" % git pull origin master
" % cd GIT_ROOT_DIR
" % git add dot.vim/neobundle.vim.git
" % git commit -m 'update neobundle.vim'

set nocompatible
filetype off

if has('vim_starting')
  if has("win32") || has("win64")
    set runtimepath+=~/vimfiles/neobundle.vim.git
    call neobundle#rc(expand('~/vimfiles/bundle'))
  else 
    set runtimepath+=~/.vim/neobundle.vim.git
    call neobundle#rc(expand('~/.vim/bundle'))
  endif
endif

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" original repos on github
" build vimproc : % cd dot.vim/bundle/vimproc/ && make -f make_gcc.mak
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'heavenshell/vim-jsdoc'
NeoBundle 'othree/eregex.vim'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'ujihisa/ref-hoogle'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'tyru/coolgrep.vim'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'kien/ctrlp.vim'

" vim-scripts repos
NeoBundle 'matchit.zip'
NeoBundle 'errormarker.vim'
NeoBundle 'surround.vim'

" non github repos
"NeoBundle 'git://git.wincent.com/command-t.git'


filetype plugin indent on

" vim:set ft=vim foldmethod=marker:
