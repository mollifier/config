# zshenv

# set PATH
mergepath () {
    local directory="$1"
    local before_or_after="$2"

    if ! echo ":${PATH}:" | /bin/fgrep ":${directory}:" > /dev/null 2>&1 ; then
        # doesn't exist in PATH
        if [[ "${before_or_after}" == "before" ]]; then
            PATH="${directory}:${PATH}"
        else
            PATH="${PATH}:${directory}"
        fi
        export PATH
    fi
}

# add "${HOME}/bin" to PATH
mergepath "${HOME}/bin" "after"

# for java
if [ -d "/usr/java/default" ]; then
    export JAVA_HOME="/usr/java/default"
    mergepath "${JAVA_HOME}/bin" "before"
fi

unfunction  mergepath

# vim:set ft=zsh:
