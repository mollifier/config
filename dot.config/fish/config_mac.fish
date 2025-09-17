if type -q brew
  brew shellenv fish | source
end

# deno
# https://deno.land/
# for vim plugins (ddc.vim)
set -x DENO_INSTALL $HOME/.deno
fish_add_path --path $DENO_INSTALL/bin
