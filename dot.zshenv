# zshenv

typeset -U path cdpath fpath manpath

# set PATH
path=($HOME/bin(N-/) /usr/local/bin(N-/) $path)

if [[ -f ~/.zshenv_dev ]]; then
    source ~/.zshenv_dev
fi

# vim:set ft=zsh:
