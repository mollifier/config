" vundle.vim
" https://github.com/gmarik/vundle
"
" install vundle
" % git submodule add http://github.com/gmarik/vundle.git ~/etc/config/dot.vim/vundle.git
"
" git submodule init
" % cd ~/etc/config
" % git submodule init
" % git submodule update
"
" install plugins from shell
" % vim -u ~/.bundles.vim +BundleInstall +q
"
" install
" :BundleInstall
"
" install and update
" :BundleInstall!

set nocompatible
filetype off

if has("win32") || has("win64")
  set rtp+=~/vimfiles/vundle.git
  call vundle#rc('~/vimfiles/bundle')
else 
  set rtp+=~/.vim/vundle.git
  call vundle#rc()
endif

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" original repos on github
" build vimproc : % cd dot.vim/bundle/vimproc/ && make -f make_gcc.mak
Bundle 'Shougo/vimproc'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neosnippet'
Bundle 'scrooloose/nerdtree.git'
Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'
Bundle 'teramako/jscomplete-vim'
Bundle 'heavenshell/vim-jsdoc'
Bundle 'othree/eregex.vim'
Bundle 'kana/vim-filetype-haskell'
Bundle 'ujihisa/ref-hoogle'
Bundle 'ujihisa/neco-ghc'
Bundle 'derekwyatt/vim-scala'
Bundle 'tomasr/molokai'
Bundle 'nanotech/jellybeans.vim'
Bundle 'tyru/coolgrep.vim'

" vim-scripts repos
Bundle 'matchit.zip'
Bundle 'errormarker.vim'
Bundle 'surround.vim'

" non github repos
"Bundle 'git://git.wincent.com/command-t.git'


filetype plugin indent on

" vim:set ft=vim foldmethod=marker:
