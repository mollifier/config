# ~/.config/fish/config.fish

############################################################
# environment variables #{{{1

set -x LANG ja_JP.UTF-8
set -x EDITOR vim
set -x TERM xterm-256color
set -x PAGER less
# --SILENT : terminal bell is not rung
set -x LESS '--tabs=4 --no-init --LONG-PROMPT --ignore-case --SILENT'
set -x MAIL /var/mail/$USERNAME
#export PS4 for bash
set -x PS4 '-> $LINENO: '

# PATH
# Specify --path option to don't use a universal fish_user_paths
if test -d $HOME/go/bin
  fish_add_path --path $HOME/go/bin # $GOPATH/bin
end
if test -d $HOME/.fzf/bin
  fish_add_path --path $HOME/.fzf/bin # local installed fzf
end
fish_add_path --path /usr/local/bin
fish_add_path --path /usr/local/sbin
fish_add_path --path $HOME/bin

# special variables #{{{1
set fish_escape_delay_ms 500

# remove the greeting message
set fish_greeting

# aliases #{{{1

#list
alias ls='ls -F --color=auto'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias ld='ls -d'
alias l1='ls -1'
alias lt='tree -F'

#file operation
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

#cd
alias c='cd'
alias c-='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

#vi
alias vi='vim'
alias v='vim'
alias vir='vim -R'
alias vr='vim -R'
alias winvi='vim -c "edit ++fileformat=dos ++enc=cp932"'
alias eucvi='vim -c "edit ++enc=euc-jp"'
alias gm='gvim'

#grep
alias gf='grep --with-filename --line-number'
alias gr='grep --with-filename --line-number --recursive --exclude-dir=.svn'

# show all histories
alias his='history'
# show recent 10 histories
alias h='history --max=10 | cat'

#etc
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
alias mkzip='zip -q -r'
alias pc=pwd-clip
alias sc=scala
alias scc=scalac
alias csc=scalac
# e.g. 'body 10:20' prints lines 10 to 20
alias body='bat --style=plain --pager=never --line-range'

function pwd-clip
  pwd | tr -d '\n' | copy_to_clipboard
end

if type -q fdfind
  alias fd=fdfind
end
if type -q batcat
  alias bat=batcat
end

# require: bat : https://github.com/sharkdp/bat
function cman --wraps man --description 'Colorized man'
  man -P 'col -bx | bat --language man --style plain --paging always' $argv
end

alias be='bundle exec'

# global-abbreviation #{{{1
# Require fish 3.6.0
function copy_to_clipboard
  if type -q pbcopy
    # Mac
    pbcopy
  else if type -q xsel
    # Linux
    xsel --input --clipboard
  end
end

abbr --add L --position anywhere '| less'
abbr --add H --position anywhere '| head'
abbr --add T --position anywhere '| tail'
abbr --add G --position anywhere '| grep'
abbr --add V --position anywhere '| vim -R -'
abbr --add C --position anywhere '| copy_to_clipboard'
abbr --add J --position anywhere '| jq "." | bat --language json'
abbr --add B --position anywhere '| bat'
abbr --add P --position anywhere '| bat --language help'
abbr --add M --position anywhere '| bat --language man'

# fisher packages
# https://github.com/jorgebucaran/fisher
#
# Install fisher
# $ curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
#
# Update fisher
# $ fisher self-update
#
# Install or Update packages
# set this file to ~/.config/fish/fishfile, and run next command
# $ fisher

# decors/fish-ghq #{{{1
# require fzf https://github.com/junegunn/fzf
set -g GHQ_SELECTOR fzf
set -g GHQ_SELECTOR_OPTS --exact --no-sort --reverse --ansi --color 'bg+:13,hl:3,pointer:7'

# PatrickF1/fzf.fish #{{{1
# require fzf https://github.com/junegunn/fzf
# require fd https://github.com/sharkdp/fd
# require bat https://github.com/sharkdp/bat
#
# key bindings
# type `fzf_configure_bindings --help` for more information
fzf_configure_bindings \
  --directory=\cxf \
  --git_log=\cxl \
  --git_status=\cxs \
  --history=\cr \
  --variables= \
  --processes

# mollifier/fish-cd-gitroot #{{{1
# Add alias
alias cdu='cd-gitroot'

# env #{{{1
#
# anyenv
# https://github.com/anyenv/anyenv
#
# Init anyenv
# Note: require to run shell as login shell in terminal startup
if test -d $HOME/.anyenv/bin
  fish_add_path --path $HOME/.anyenv/bin
end
if type -q anyenv
  status --is-interactive; and status --is-login; and source (anyenv init - fish|psub)
end

# direnv #{{{1
# https://github.com/zimbatm/direnv
if type -q direnv
  eval (direnv hook fish)
end

switch (uname)
  case Linux
    test -f ~/.config/fish/config_linux.fish; and source ~/.config/fish/config_linux.fish
  case Darwin
    # Mac
    test -f ~/.config/fish/config_mac.fish; and source ~/.config/fish/config_mac.fish
end

