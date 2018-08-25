# zshenv

typeset -U path cdpath fpath manpath

# set PATH
path=($HOME/bin(N-/) /usr/local/sbin(N-/) /usr/local/bin(N-/) $path)

# zshenv for development environment settings

## java ##
if [[ -d "/usr/lib/jvm/java-7-oracle" ]]; then
    # Ubuntu
    export JAVA_HOME="/usr/lib/jvm/java-7-oracle"
elif [[ -x "/usr/libexec/java_home" ]]; then
    # Mac
    export JAVA_HOME=$(/usr/libexec/java_home)
elif [[ -d "/System/Library/Frameworks/JavaVM.framework/Home" ]]; then
    # Mac
    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
fi

path=(${JAVA_HOME:+${JAVA_HOME}/bin}(N-/) $path)


## scala ##
# svm
# http://github.com/yuroyoro/svm
if [[ -d "${HOME}/.svm/current/rt" ]]; then
    export SCALA_HOME=${HOME}/.svm/current/rt
    path=(${SCALA_HOME:+${SCALA_HOME}/bin}(N-/) $path)
fi


## Play Framework ##
path=($HOME/local/play/latest(N-/) $path)

## node.js (nodebrew) ##
path=($HOME/.nodebrew/current/bin(N-/) $path)

## haskell (cabal) ##
path=($HOME/Library/Haskell/bin(N-/) $path)

### Added by the Heroku Toolbelt
path=(/usr/local/heroku/bin(N-/) $path)

## Android SDK ##
if [[ -d "${HOME}/local/android-sdk-macosx" ]]; then
    export ANDROID_HOME=${HOME}/local/android-sdk-macosx
fi
if [[ -n "$ANDROID_HOME" && -d "$ANDROID_HOME" ]]; then
    path=($path ${ANDROID_HOME}/tools(N-/) ${ANDROID_HOME}/platform-tools(N-/) ${ANDROID_HOME}/build-tools/android-4.4(N-/))
fi

# added by travis gem
[ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh

# Go
if [[ -d "${HOME}/local/gocode" ]]; then
    export GOPATH=${HOME}/local/gocode
    path=($path ${GOPATH}/bin)
fi

# Perl
export PERL_CPANM_OPT="--local-lib=~/perl5"
path=($path $HOME/perl5/bin(N-/))
export PERL5LIB=$HOME/perl5/lib/perl5:$PERL5LIB;

# pyenv (Python)
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "${PYENV_ROOT}" ]]; then
    path=($PYENV_ROOT/shims(N-/) $path)    # for Mac
    path=($PYENV_ROOT/bin(N-/) $path)
    eval "$(pyenv init -)"
fi

# vim:set ft=zsh ts=4 sw=4 sts=0 foldmethod=marker:
