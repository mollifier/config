" https://github.com/junegunn/vim-plug
"
" Install or update vim-plug
" $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Install plugins
" Open vim and run next command
" :PlugInstall
" or run next command from shell.
" $ vim -es -u ~/.vimplug.vim -i NONE -c 'PlugInstall' -c 'qa'
"
" Update plugins
" Open vim and run next command
" :PlugUpdate
" or run next command from shell.
" $ vim -es -u ~/.vimplug.vim -i NONE -c 'PlugUpdate' -c 'qa'
"
" Remove plugins
" Open vim and run next command
" :PlugClean
" or run next command from shell.
" $ vim -es -u ~/.vimplug.vim -i NONE -c 'PlugClean' -c 'qa'

call plug#begin('~/.cache/vimplug')

Plug 'thinca/vim-quickrun'
Plug 'othree/eregex.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-surround'
Plug 'dag/vim-fish'
Plug 'tyru/caw.vim' " Vim comment plugin
Plug 'tmhedberg/matchit'
Plug 'plasticboy/vim-markdown'
Plug 'mattn/vim-maketable'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'liuchengxu/vista.vim'
Plug 'itchyny/lightline.vim'
Plug 'lambdalisue/fern.vim'
Plug 'HiPhish/info.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" colorscheme
Plug 'yasukotelin/shirotelin'
Plug 'joshdick/onedark.vim'
Plug 'wadackel/vim-dogrun'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
