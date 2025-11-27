#!/usr/bin/env bash

if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then 
    tmux new-session -A -s ${USER} >/dev/null 2>&1
fi

fastfetch

set -o vi

export EDITOR=$(command -v nvim || command -v vim)

eval "$(starship init bash)"
