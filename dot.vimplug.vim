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

Plug 'machakann/vim-sandwich'
Plug 'thinca/vim-quickrun'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/committia.vim'
Plug 'vim-syntastic/syntastic'
Plug 'dag/vim-fish'
Plug 'tyru/caw.vim' " Vim comment plugin
Plug 'tmhedberg/matchit'
Plug 'plasticboy/vim-markdown'
Plug 'mattn/vim-maketable'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'liuchengxu/vista.vim'
Plug 'itchyny/lightline.vim'
Plug 'unblevable/quick-scope'
Plug 'bkad/CamelCaseMotion'
Plug 'simeji/winresizer'

" fern
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'yuki-yano/fern-preview.vim'

Plug 'HiPhish/info.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" ddc.vim
" Dark deno-powered completion framework
" require Deno
" brew install deno
" https://deno.land/
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
" Install your UIs
Plug 'Shougo/ddc-ui-native'
" Install your sources
Plug 'Shougo/ddc-source-around'
Plug 'shun/ddc-source-vim-lsp'
Plug 'LumaKernel/ddc-source-file'
" Install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-filter-converter_remove_overlap'

" colorscheme
Plug 'yasukotelin/shirotelin'
Plug 'joshdick/onedark.vim'
Plug 'wadackel/vim-dogrun'
Plug 'arcticicestudio/nord-vim'
Plug 'EdenEast/nightfox.nvim'
Plug 'EdenEast/duskfox.nvim'
Plug 'EdenEast/nordfox.nvim'
Plug 'cocopon/iceberg.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
