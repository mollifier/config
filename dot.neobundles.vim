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
" % cd GIT_ROOT_DIR
" % git submodule foreach git pull origin master
" % git add dot.vim/neobundle.vim.git
" % git commit -m 'update neobundle.vim'

if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

filetype off

if has('vim_starting')
  if has("win32") || has("win64")
    set runtimepath+=~/vimfiles/neobundle.vim.git
    call neobundle#begin(expand('~/vimfiles/bundle'))
  else 
    set runtimepath+=~/.vim/neobundle.vim.git
    call neobundle#begin(expand('~/.vim/bundle/'))
  endif
endif

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" original repos on github
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'basyura/unite-rails'
NeoBundle 'Shougo/unite-outline'

NeoBundle 'kana/vim-textobj-user'
NeoBundle 'rhysd/vim-textobj-ruby'
NeoBundle 'kana/vim-textobj-indent'

NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
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
NeoBundle 'tpope/vim-rails'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'rcmdnk/vim-markdown'
NeoBundle 'rhysd/committia.vim'
NeoBundle 'scrooloose/syntastic'

" vim-scripts repos
NeoBundle 'matchit.zip'
NeoBundle 'errormarker.vim'
NeoBundle 'surround.vim'
NeoBundle 'wombat256.vim'

" non github repos
"NeoBundle 'git://git.wincent.com/command-t.git'

call neobundle#end()

filetype plugin indent on

" vim:set ft=vim foldmethod=marker:
