#!/bin/bash

##########################################################
# make symbolic links to dotfiles
##########################################################

#set -o noglob

#####################
# constants
#####################
declare -r SCRIPT_NAME=${0##*/}
tmp_src_dir_name=$(dirname "$0")
declare -r SRC_DIR_NAME=${tmp_src_dir_name}
declare -r DEST_DIR_NAME=${HOME}

declare -ar DOTFILES=(
  'dot.atoolrc'
  'dot.bash_profile'
  'dot.bashrc'
  'dot.emacs'
  'dot.gitconfig'
  'dot.gitignore'
  'dot.gvimrc'
  'dot.inputc'
  'dot.npmrc'
  'dot.screenrc'
  'dot.tmux.conf'
  'dot.vim'
  'dot.vimrc'
  'dot.vimplug.vim'
  'dot.Xmodmap'
  'dot.zshenv'
  'dot.zlogin'
  'dot.zprofile'
  'dot.zshrc'
  'dot.zlogout'
  'dot.peco_config.json'
  'dot.config/bat/config'
  'dot.config/alacritty/alacritty.toml'
  'dot.config/wezterm/wezterm.lua'
  'dot.config/fish/config.fish'
  'dot.config/fish/config_linux.fish'
  'dot.config/fish/config_mac.fish'
  'dot.config/fish/fish_plugins'
  'dot.config/fish/functions/fish_user_key_bindings.fish'
  'dot.config/fish/functions/user_z_select_and_change_directory.fish'
)

#####################
# functions
#####################

print_usage()
{
    cat << EOF
Usage: $SCRIPT_NAME [-df]
Make symbolic links to dotfiles in HOME.

  -d           dry run
               not make link, but display ln command
               [default]

  -f           make link actually

  -h           display this help and exit
EOF
}

print_error()
{
    echo "$SCRIPT_NAME: $*" 1>&2
    echo "Try \`-h' option for more information." 1>&2
}

# create dest filename by link src filename
get_dest_filename()
{
  # complex sed substitution is required
  # shellcheck disable=SC2001
  echo "${1}" | sed -e 's/^dot\././'
}

#####################
# main
#####################

# false : not make link
# true : make link actually
make_link="false"

while getopts ':fdh' option; do
    case $option in
    f)
        make_link="true"
        ;;
    d)
        make_link="false"
        ;;
    h)
        print_usage
        exit 0
        ;;
    :)  # option argument is missing
        print_error "option requires an argument -- $OPTARG"
        exit 1
        ;;
    *)  # unknown option
        print_error "invalid option -- $OPTARG"
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

cd "$SRC_DIR_NAME" || exit
for src_filename in "${DOTFILES[@]}"; do
  dest_filename=$(get_dest_filename "$src_filename")

  if [ -e "${DEST_DIR_NAME}/${dest_filename}" ]; then
    # skip file which already exists
    continue
  fi

  if [ "$make_link" == "true" ]; then
    # make link actually
    ln -s "${PWD}/${src_filename}" "${DEST_DIR_NAME}/${dest_filename}"
  else
    # not make link, but echo command
    echo ln -s "${PWD}/${src_filename}" "${DEST_DIR_NAME}/${dest_filename}"
  fi
done

exit $?

