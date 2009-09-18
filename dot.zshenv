# zshenv

export JAVA_HOME='/usr/lib/jvm/java-6-sun'

# set PATH
typeset -U path
path=($HOME/bin(N-/) $JAVA_HOME/bin(N-/) $path)


# vim:set ft=zsh:
