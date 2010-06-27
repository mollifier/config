# zshenv

# java
if [[ -d "/usr/lib/jvm/java-6-sun" ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-6-sun"
elif [[ -d "/usr/lib/jvm/java-6-openjdk" ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-6-openjdk"
fi


# set PATH
typeset -U path
path=($HOME/bin(N-/) $JAVA_HOME/bin(N-/) $path)


# vim:set ft=zsh:
