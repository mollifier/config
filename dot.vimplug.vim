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
" $ vim -u ~/.vimplug.vim '+PlugInstall'
"
" Update plugins
" Open vim and run next command
" :PlugUpdate
" or run next command from shell.
" $ vim -u ~/.vimplug.vim '+PlugUpdate'
"
" Remove plugins
" Open vim and run next command
" :PlugClean
" or run next command from shell.
" $ vim -u ~/.vimplug.vim '+PlugClean'

call plug#begin('~/.cache/vimplug')

Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'thinca/vim-quickrun'
Plug 'othree/eregex.vim'
Plug 'editorconfig/editorconfig-vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
