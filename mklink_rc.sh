#!/bin/bash

##########################################################
# シェルスクリプト テンプレート
##########################################################

#set -o noglob

#####################
#定数
#####################
declare -r SCRIPT_NAME=${0##*/}


#####################
#関数
#####################

#ヘルプを出力する
print_usage()
{
    cat << EOF
Usage: $SCRIPT_NAME [-v] [-t TYPE] FILE
Shell script template.

  -v           verbosely display error message
  -t TYPE      specify filetype
  -h           display this help and exit
EOF
}

#エラーを出力する
print_error()
{
    echo "$SCRIPT_NAME: $@" 1>&2
    echo "Try \`-h' option for more information." 1>&2
}


#####################
#メイン処理
#####################

#変数
verbose=0
type=''
file_name=''

#引数解析
while getopts ':vt:h' option; do
    case $option in
    v)
        verbose=1
        ;;
    t)
        type=$OPTARG
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

file_name=$1

if [ -z "$file_name" ]; then
    print_error 'you must specify filename'
    exit 1
fi

    cat << EOF
VERBOSE   = $verbose
TYPE      = $type
FILE NAME = $file_name
EOF

exit $?

