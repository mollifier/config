#!/bin/bash

##########################################################
# make symbolic links to dotfiles
##########################################################

#set -o noglob

#####################
# constatns
#####################
declare -r SCRIPT_NAME=${0##*/}
declare -r SRC_DIR_NAME=$(dirname $0)
declare -r DEST_DIR_NAME=${HOME}

declare -ar DOTFILES=(
  'dot.atoolrc'
  'dot.bash_profile'
  'dot.bundles.vim'
  'dot.bashrc'
  'dot.emacs'
  'dot.gitconfig'
  'dot.gitignore'
  'dot.gvimrc'
  'dot.inputc'
  'dot.npmrc'
  'dot.screenrc'
  'dot.vim'
  'dot.vimperator'
  'dot.vimperatorrc'
  'dot.vimrc'
  'dot.Xmodmap'
  'dot.zshenv'
  'dot.zshrc'
  'dot.zlogout'
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
    echo "$SCRIPT_NAME: $@" 1>&2
    echo "Try \`-h' option for more information." 1>&2
}

# create dest filename by link src filename
get_dest_filename()
{
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
shift $(expr $OPTIND - 1)

cd $SRC_DIR_NAME
for src_filename in ${DOTFILES[@]};do
  dest_filename=$(get_dest_filename $src_filename)

  if [ "$make_link" == "true" ]; then
    # make link actually
    ln -s ${PWD}/${src_filename} ${DEST_DIR_NAME}/${dest_filename}
  else
    # not make link, but echo command
    echo ln -s ${PWD}/${src_filename} ${DEST_DIR_NAME}/${dest_filename}
  fi
done

exit $?

