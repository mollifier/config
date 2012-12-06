# zshrc


############################################################
# basic #{{{1

umask 022
limit coredumpsize 0
stty erase '^h'

# make directory for cdd, completion cache, ...
_zsh_user_config_dir="${HOME}/.zsh"
if [[ ! -d ${_zsh_user_config_dir} ]]; then
    mkdir -p ${_zsh_user_config_dir}
fi

autoload -Uz add-zsh-hook


############################################################
# environment variables #{{{1

export LANG=ja_JP.UTF-8
export EDITOR=vim
export TERM=xterm-256color
export PAGER=less
# --SILENT : terminal bell is not rung
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --SILENT'
export GREP_OPTIONS='--color=auto'
export MAIL=/var/mail/$USERNAME
#export PS4 for bash
export PS4='-> $LINENO: '

if [[ -d "/usr/share/zsh/help/" ]]; then
    export HELPDIR=/usr/share/zsh/help/
fi

# ls color #{{{2
if which dircolors >/dev/null 2>&1 ;then
    # export LS_COLORS
    eval $(dircolors -b)
    #not use bold
    if which perl >/dev/null 2>&1 ;then
        LS_COLORS=$(echo $LS_COLORS | LANG=C perl -pe 's/(?<= [=;] ) 01 (?= [;:] )/00/xg')
    fi
else
    # dircolors is not found
    export LS_COLORS='di=00;34:ln=00;36:so=00;35:ex=00;32:bd=40;33;00:cd=40;33;00:su=37;41:sg=30;43:tw=30;42:ow=34;42'
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


############################################################
# key bind #{{{1

bindkey -e

bindkey '^V' vi-quoted-insert
bindkey "^[u" undo
bindkey "^[r" redo
# not accept-line, but insert newline
bindkey '^J' self-insert-unmeta
bindkey '^R' history-incremental-pattern-search-backward

# like insert-last-word,
# except that non-words are ignored
autoload -Uz smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
#   include words that is at least two characters long
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey '^]' insert-last-word

# like delete-char-or-list, except that list-expand is used
function _delete-char-or-list-expand() {
    if [[ -z "${RBUFFER}" ]]; then
        # the cursor is at the end of the line
        zle list-expand
    else
        zle delete-char
    fi
}
zle -N _delete-char-or-list-expand
bindkey '^D' _delete-char-or-list-expand

# kill backward one word,
# where a word is defined as a series of non-blank characters
function _kill-backward-blank-word() {
    zle set-mark-command
    zle vi-backward-blank-word
    zle kill-region
}
zle -N _kill-backward-blank-word
bindkey '^Y' _kill-backward-blank-word

# history-search-end:
# This implements functions like history-beginning-search-{back,for}ward,
# but takes the cursor to the end of the line after moving in the
# history, like history-search-{back,for}ward.
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^O" history-beginning-search-backward-end

# quote previous word in single or double quote
autoload -Uz modify-current-argument
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^[s' _quote-previous-word-in-single

_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^[d' _quote-previous-word-in-double

# quote URL
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


############################################################
# default configuration #{{{1

#set PROMPT
autoload -Uz colors
colors

if [[ -z "${REMOTEHOST}${SSH_CONNECTION}" ]]; then
    #local shell
    PROMPT="%U%{${fg[red]}%}[%n@%m]%{${reset_color}%}%u(%j) %~
%# "
else
    #remote shell
    PROMPT="%U%{${fg[blue]}%}[%n@%m]%{${reset_color}%}%u(%j) %~
%# "
fi

# show vcs information #{{{2
# see man zshcontrib(1)
# GATHERING INFORMATION FROM VERSION CONTROL SYSTEMS
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true


autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"    # %c
  zstyle ':vcs_info:git:*' unstagedstr "-"  # %u
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u %m'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u %m'
fi

if is-at-least 4.3.11; then
    # git: show marker (?) if there are untracked files in repository
    # Make sure you have added misc to your 'formats':  %u
    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
    function +vi-git-untracked() {
        if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep '\?\?' &> /dev/null ; then

            hook_com[unstaged]+='?'
        fi
    }

    # git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
    # Make sure you have added misc to your 'formats':  %m
    zstyle ':vcs_info:git*+set-message:*' hooks git-push-status
    function +vi-git-push-status() {
        local ahead behind
        local -a gitstatus

        # not push
        ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        (( $ahead )) && gitstatus+=( "p${ahead}" )

        behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        (( $behind )) && gitstatus+=( "o${behind}" )

        if (( ${#gitstatus} )); then
            hook_com[misc]+="(${(j:/:)gitstatus})"
        fi
    }

fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{green}%1v%f|)"
# }}}2

#history configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_save_nodups
#remove the history (fc -l) command from the history list
setopt hist_no_store
setopt hist_ignore_space
setopt hist_reduce_blanks
# do not add unnecessary command line to history
_history_ignore() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    [[ ${#line} -ge 5
        && ${cmd} != "rm"
        && ${cmd} != (l|l[sal])
        && ${cmd} != (c|cd)
        && ${cmd} != (m|man)
    ]]
}
add-zsh-hook zshaddhistory _history_ignore


# completion #{{{2
autoload -Uz compinit
compinit

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ignore current directory
# .. : only when the word on the line contains the substring '../'
zstyle ':completion:*' ignore-parents parent pwd ..

zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

setopt auto_menu
setopt extended_glob
#expand argument after = to filename
setopt magic_equal_subst
setopt print_eight_bit
setopt mail_warning
# remove right prompt from display when accepting a command line.
setopt transient_rprompt

zstyle ':completion:*:default' menu select=1
if [[ -d ${_zsh_user_config_dir}/cache ]]; then
    zstyle ':completion:*' use-cache yes
    zstyle ':completion:*' cache-path ${_zsh_user_config_dir}/cache
fi

# grouping cd completions
zstyle ':completion:*:cd:*' group-name ''
zstyle ':completion:*:cd:*:descriptions' format '%B%U# %d%u%b'
# }}}2


#cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
cdpath=(${HOME} ${HOME}/work)

# set characters which are considered word characters
# see man zshcontrib(1)
# bash-style word functions
autoload -Uz select-word-style
select-word-style default
# only these characters are not considered word characters
zstyle ':zle:*' word-chars " /;@:{},|"
zstyle ':zle:*' word-style unspecified

# run-help
[ -n "$(alias run-help)" ] && unalias run-help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-svn

#etc
#allow comments in interactive shell
setopt interactive_comments
setopt rm_star_silent
setopt no_prompt_cr

setopt auto_remove_slash

#disable flow control
setopt no_flow_control

#not exit on EOF
setopt ignore_eof

#never ever beep ever
setopt no_beep


############################################################
# utility functions #{{{1

function alc() {
    if [ -n "$1" ]; then
        w3m "http://eow.alc.co.jp/${1}/UTF-8/?ref=sa" | sed '1,36d' | less
    else
        echo 'usage: alc word'
    fi
}

function presentation() {
    PROMPT="[%1d] %# "
    RPROMPT=""
}

function body() {
    if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]] ; then
        echo "usage: $0 START,END [FILE]"
        return
    fi

    local exp="${1}"
    shift
    sed -n -e "${exp}p" $@
}

# cd to git repository root directory
# http://d.hatena.ne.jp/hitode909/20100211/1265879271
function cdu() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}

function pwd-clip() {
    local copyToClipboard

    if which pbcopy >/dev/null 2>&1 ; then
        # Mac
        copyToClipboard='pbcopy'
    elif which xsel >/dev/null 2>&1 ; then
        # Linux
        copyToClipboard='xsel --input --clipboard'
    elif which putclip >/dev/null 2>&1 ; then
        # Cygwin
        copyToClipboard='putclip'
    else
        copyToClipboard='cat'
    fi

    # ${=VAR} enables SH_WORD_SPLIT option
    # so ${=VAR] is splited in words, for example "a" "b" "c"
    echo -n $PWD | ${=copyToClipboard}
}

function scouter() {
    sed -e '/^\s*$/d' -e '/^\s*#/d' ${ZDOTDIR:-$HOME}/.zshrc | wc -l
}

function 256colortest() {
    local code
    for code in {0..255}; do
        echo -e "\e[38;05;${code}m $code: Test"
    done
}

function zsh-without-rcfiles-in-screen() {
    # RCS option :
    #   If this option is unset, source /etc/zsh/zshenv
    #   but any other startup files will not be.
    # +o :
    #  unset RCS option
    screen zsh +o RCS
}


############################################################
# aliases #{{{1

#list
alias ls='ls -F --color=auto'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ld='ls -d'
alias l1='ls -1d'
alias lt='tree -F'

#file operation
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

#vi
alias vi='vim'
alias v='vim'
alias vir='vim -R'
alias vr='vim -R'
alias winvi='vim -c "edit ++fileformat=dos ++enc=cp932"'
alias eucvi='vim -c "edit ++enc=euc-jp"'
alias gm='gvim'

#grep
alias grep='grep -E'
alias gf='grep --with-filename --line-number'
alias gr='grep --with-filename --line-number --recursive --exclude-dir=.svn'

#history
#-n option suppresses command numbers
function my_history_func() {
    local number=${1:-10}
    builtin history -n -${number}
}

alias history='builtin history 1'
alias his='builtin history -n 1'
alias h=my_history_func

#enable alias to sudo command argument
alias sudo='sudo '

#etc
alias c='cd'
alias g='git'
alias s='svn'
alias dirs='dirs -p'
alias ln='ln -s'
alias jb='jobs -l'
alias sc=screen
alias m='man'
alias eman="LANG=C man"
alias em="LANG=C man"
alias di='diff -u'
alias rlocate='locate --regex'
alias ema='emacs -nw'
alias mkzip='zip -q -r'
alias pc=pwd-clip

autoload -Uz zmv
alias zmv='noglob zmv -n -W'
alias dozmv='noglob zmv -W'

function make_date_dir_and_cd() {
    local date_dir=$(date '+%Y-%m-%d')
    if [ ! -d "$date_dir" ]; then
        mkdir "$date_dir" || return
    fi
    cd "$date_dir"
}
alias ddir='make_date_dir_and_cd'

alias svngrep='find . -type d -name .svn -prune -o -type f -print0 \
  | xargs -0 grep --with-filename --line-number'

#global aliases
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g V='| vim -R -'
alias -g U=' --help | head'
alias -g P=' --help | less'
alias -g N='> /dev/null'
alias -g W='| w3m -T text/html'

if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi


# for plugins #{{{1
# cdd
cdd_script_path=~/etc/config/zsh/cdd
if [[ -f $cdd_script_path ]]; then
    source $cdd_script_path
    function _cdd_chpwd() {
        _reg_pwd_screennum
    }
    add-zsh-hook chpwd _cdd_chpwd
fi
unset cdd_script_path

# z
# https://github.com/rupa/z
rupa_z_script_path=~/etc/config/zsh/z.sh
if [[ -f $rupa_z_script_path ]]; then
    source $rupa_z_script_path
    function _rupa_z_chpwd() {
        _z --add "$(pwd -P)"
    }
    add-zsh-hook chpwd _rupa_z_chpwd
fi
unset rupa_z_script_path

if [[ -f ~/.zshrc_dev ]]; then
    source ~/.zshrc_dev
fi

# source local rcfile
if [[ -f ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi

unset _zsh_user_config_dir

# vim:set ft=zsh ts=4 sw=4 sts=0 foldmethod=marker:
