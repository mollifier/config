# bash_profile

# set PATH
mergepath() {
    local directory="$1"
    local before_or_after="$2"

    if ! echo ":${PATH}:" | /bin/fgrep ":${directory}:" > /dev/null 2>&1 ; then
        # "directory" doesn't exist in PATH
        if [ "${before_or_after}" == "before" ]; then
            PATH="${directory}:${PATH}"
        else
            PATH="${PATH}:${directory}"
        fi
        export PATH
    fi
}

if [ -d "${HOME}/bin" ]; then
    mergepath "${HOME}/bin" "after"
fi

# for java
if [ -d "/usr/java/default" ]; then
    export JAVA_HOME="/usr/java/default"
    mergepath "${JAVA_HOME}/bin" "before"
fi

unset -f mergepath 

unset USERNAME

# anyenv / nodenv
if [[ -d "$HOME/.anyenv" ]] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init - bash)"
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# vim:set ft=sh:
