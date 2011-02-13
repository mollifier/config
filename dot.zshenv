# zshenv

# java
if [[ -d "/usr/lib/jvm/java-6-sun" ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-6-sun"
elif [[ -d "/usr/lib/jvm/java-6-openjdk" ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-6-openjdk"
elif [[ -d   "/System/Library/Frameworks/JavaVM.framework/Home" ]]; then
  # Mac
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
fi


# set PATH
typeset -U path
path=($HOME/bin(N-/) ${JAVA_HOME:+${JAVA_HOME}/bin}(N-/) /usr/local/bin(N-/) $path)

# node.js
path=($HOME/local/node/bin(N-/) $path)


# vim:set ft=zsh:
