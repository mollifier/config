# zshrc


umask 022
limit coredumpsize 0
stty erase '^h'

autoload -Uz add-zsh-hook

##############################
#environment variables
##############################

export LANG=ja_JP.UTF-8
export EDITOR=vim
export TERM=xterm-256color
export PAGER=less
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'
export GREP_OPTIONS='--color=auto'
export MAIL=/var/mail/$USERNAME
#export PS4 for bash
export PS4='-> $LINENO: '

if [[ -d "/usr/share/zsh/help/" ]]; then
    export HELPDIR=/usr/share/zsh/help/
fi

#ls color
if which dircolors >/dev/null 2>&1 ;then
    eval $(dircolors -b)
    #not use bold
    if which perl >/dev/null 2>&1 ;then
        LS_COLORS=$(echo $LS_COLORS | LANG=C perl -pe 's/(?<= [=;] ) 01 (?= [;:] )/00/xg')
        zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    fi
fi


##############################
#key bind
##############################
bindkey -e

bindkey '^V' vi-quoted-insert
bindkey "^[u" undo
bindkey "^[r" redo
# not accept-line, but insert newline
bindkey '^J' self-insert-unmeta
bindkey '^R' history-incremental-pattern-search-backward

# like insert-last-word,
# except that non-words are ignored
autoload smart-insert-last-word
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
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^O" history-beginning-search-backward-end

# quote previous word in single or double quote
autoload -U modify-current-argument
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

##############################
#default configuration
##############################

#set PROMPT
autoload -U colors
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

# show vcs information
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
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
RPROMPT="%1(v|%F{green}%1v%f|)"


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

#completion
autoload -U compinit
compinit

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
if [[ -d ~/.zsh/cache ]]; then
    zstyle ':completion:*' use-cache yes
    zstyle ':completion:*' cache-path ~/.zsh/cache
fi


#cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
cdpath=(${HOME} ${HOME}/work)
# grouping cd completions
zstyle ':completion:*:cd:*' group-name ''
zstyle ':completion:*:cd:*:descriptions' format '%B%U# %d%u%b'


#etc
#allow comments in interactive shell
setopt interactive_comments
setopt rm_star_silent
setopt no_prompt_cr

#not include / in word characters
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt auto_remove_slash

#disable flow control
setopt no_flow_control

#not exit on EOF
setopt ignore_eof

#never ever beep ever
setopt no_beep

##############################
#special functions
##############################

# do not add unnecessary command line to history
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    [[ ${#line} -ge 5
        && ${cmd} != "rm"
        && ${cmd} != (l|l[sal])
        && ${cmd} != (c|cd)
        && ${cmd} != (m|man)
    ]]
}

##############################
#utility functions
##############################
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

# usage : body 5,8 [FILE]
function body() {
    local exp="${1}"
    if [ $# -gt 0 ] ; then
      shift
    fi
    sed -n -e "${exp}p" $@
}


##############################
#aliases
##############################

#list
alias ls='ls -F --color=auto'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ld='ls -d'
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
alias ddir="mkdir $(date '+%Y-%m-%d')"

#global aliases
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc'
alias -g V='| vim -R -'
alias -g U=' --help | head'
alias -g P=' --help | less'
alias -g N='> /dev/null'

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


# cdd
cdd_script_path=~/etc/config/zsh/cdd
if [[ -f $cdd_script_path ]]; then
    source $cdd_script_path
    function chpwd() {
        _reg_pwd_screennum
    }
fi
unset cdd_script_path

# source local rcfile
if [[ -f ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi

# vim:set ft=zsh:
