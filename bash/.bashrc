#!/usr/bin/env bash

export EDITOR=$(command -v nvim || command -v vim)

set -o vi

eval "$(starship init bash)"

fastfetch

if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then 
    tmux new-session -A -s ${USER} >/dev/null 2>&1
fi
