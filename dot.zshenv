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
if [[ -f ~/.nvm/nvm.sh ]]; then
    source ~/.nvm/nvm.sh

    if which nvm >/dev/null 2>&1 ;then
        _nodejs_use_version="v0.6.9"
        if nvm ls | grep -F -e "${_nodejs_use_version}" >/dev/null 2>&1 ;then
            nvm use "${_nodejs_use_version}" >/dev/null

            # Set module search path for node
            #
            # Use -g option to install npm module
            # for example : % npm install -g formidable.
            # When install npm module with -g option,
            # it is installed only for the version in use.
            #
            # $NVM_PATH is ${HOME}/.nvm/${_nodejs_use_version}/lib/node
            # ${NODE_PATH:+:} is substituted ":" if and only if $NODE_PATH is not empty.
            export NODE_PATH=${NVM_PATH}_modules${NODE_PATH:+:}${NODE_PATH}
        fi
        unset _nodejs_use_version
    fi
fi

# vim:set ft=zsh:
