#!/bin/bash

##########################################################
# シェルスクリプト テンプレート
##########################################################

#set -o noglob

#####################
#定数
#####################
declare -r SCRIPT_NAME=${0##*/}
declare -r SRC_DIR_NAME=$(dirname $0)
declare -r DEST_DIR_NAME=${HOME}

dotfiles=(
  'dot.atoolrc'
  'dot.bash_profile'
  'dot.bashrc'
  'dot.emacs'
  'dot.gitconfig'
  'dot.gitignore'
  'dot.gvimrc'
  'dot.screenrc'
  'dot.vim'
  'dot.vimperator'
  'dot.vimperatorrc'
  'dot.vimrc'
  'dot.xmodmaprc'
  'dot.zshenv'
  'dot.zshrc'
)

#####################
#関数
#####################

#ヘルプを出力する
print_usage()
{
    cat << EOF
Usage: $SCRIPT_NAME [-fd]
Shell script template.

  -f           verbosely display error message
  -d           dry run
  -h           display this help and exit
EOF
}

#エラーを出力する
print_error()
{
    echo "$SCRIPT_NAME: $@" 1>&2
    echo "Try \`-h' option for more information." 1>&2
}

# リンク元ファイル名からリンク先ファイル名を作成する
get_dest_filename()
{
  echo "${1}" | sed -e 's/^dot\././'
}

#####################
#メイン処理
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
    :)  #オプション引数欠如
        print_error "option requires an argument -- $OPTARG"
        exit 1
        ;;
    *)  #不明なオプション
        print_error "invalid option -- $OPTARG"
        exit 1
        ;;
    esac
done
shift $(expr $OPTIND - 1)

cd $SRC_DIR_NAME
for src_filename in ${dotfiles[@]};do
  dest_filename=$(get_dest_filename $src_filename)

  if [ "$make_link" == "true" ]; then
    ln -s ${PWD}/${src_filename} ${DEST_DIR_NAME}/${dest_filename}
  else
    echo ln -s ${PWD}/${src_filename} ${DEST_DIR_NAME}/${dest_filename}
  fi
done

exit $?

