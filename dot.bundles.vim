" vundle.vim
" https://github.com/gmarik/vundle
"
" setup vundle
" % git submodule add http://github.com/gmarik/vundle.git ~/etc/config/dot.vim/vundle.git
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

set rtp+=~/.vim/vundle.git
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" original repos on github
Bundle 'Shougo/neocomplcache'
Bundle 'scrooloose/nerdtree.git'

" vim-scripts repos
Bundle 'matchit.zip'
Bundle 'eregex.vim'

" non github repos
"Bundle 'git://git.wincent.com/command-t.git'


filetype plugin indent on

" vim:set ft=vim foldmethod=marker:
