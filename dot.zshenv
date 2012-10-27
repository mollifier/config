# zshenv

typeset -U path cdpath fpath manpath

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
path=($HOME/bin(N-/) ${JAVA_HOME:+${JAVA_HOME}/bin}(N-/) /usr/local/bin(N-/) $path)

# node.js
if [[ -f ~/.nvm/nvm.sh ]]; then
    source ~/.nvm/nvm.sh

    if which nvm >/dev/null 2>&1 ;then
        _nodejs_use_version="v0.6.13"

        _nodejs_npm_prefix="$HOME/.npm"

        if nvm ls | grep -F -e "${_nodejs_use_version}" >/dev/null 2>&1 ;then

            nvm use "${_nodejs_use_version}" >/dev/null

            # Set module search path for node
            #
            # Use -g option to install npm module
            # for example : % npm install -g formidable.
            [ -z "$node_path" ] && typeset -xT NODE_PATH node_path
            typeset -U node_path
            node_path=(${_nodejs_npm_prefix}/lib/node_modules(N-/) $node_path)

            path=(${_nodejs_npm_prefix}/bin(N-/) $path)

            manpath=(${_nodejs_npm_prefix}/share/man(N-/) $manpath)
        fi
        unset _nodejs_use_version
        unset _nodejs_npm_prefix
    fi
fi

# haskell (cabal)
path=($HOME/Library/Haskell/bin $path)

# vim:set ft=zsh:
