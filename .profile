# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/usr/local/go/bin" ]; then
    PATH="$PATH:/usr/local/go/bin"
fi

if [ -d "/usr/local/android-studio/bin" ]; then
    PATH="$PATH:/usr/local/android-studio/bin"
fi

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export VOLTA_HOME="$HOME/.volta"
if [ -d "$VOLTA_HOME/bin" ]; then
    export PATH="$VOLTA_HOME/bin:$PATH"
fi

# Set vim as default editor
VISUAL="/usr/bin/vim"
EDITOR="/usr/bin/vim"
