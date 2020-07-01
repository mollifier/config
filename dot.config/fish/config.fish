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
contains $HOME/bin $PATH; or set PATH $HOME/bin $PATH
contains /usr/local/sbin $PATH; or set PATH /usr/local/sbin $PATH
contains /usr/local/bin $PATH; or set PATH /usr/local/bin $PATH

# special variables #{{{1
set -x CDPATH . $HOME
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

alias be='bundle exec'

if type -q pbcopy
  # Mac
  alias C='pbcopy'
else if type -q xsel
  # Linux
  alias C='xsel --input --clipboard'
end

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
set -g GHQ_SELECTOR_OPTS '--exact --no-sort --reverse --ansi --color bg+:13,hl:3,pointer:7'

# jethrokuan/fzf #{{{1
# require fzf https://github.com/junegunn/fzf
# Use new keybindings
set -g FZF_LEGACY_KEYBINDINGS 0
set -g FZF_DEFAULT_OPTS '--exact --height 20 --color bg+:13,hl:3,pointer:7'

# mollifier/fish-cd-gitroot #{{{1
# Add alias
alias cdu='cd-gitroot'

# ryotako/fish-global-abbreviation #{{{1
# https://github.com/ryotako/fish-global-abbreviation
# type `gabbr -s` or `gabbr --show` to show abbreviation
set gabbr_config ~/.config/fish/gabbr_config
gabbr --reload

# env #{{{1
#
# anyenv
# https://github.com/anyenv/anyenv
#
# Init anyenv
# Note: require to run shell as login shell in terminal startup
if test -d $HOME/.anyenv/bin
  contains $HOME/.anyenv/bin $PATH; or set PATH $HOME/.anyenv/bin $PATH
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

