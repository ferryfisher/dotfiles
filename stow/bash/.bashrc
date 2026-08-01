#!/usr/bin/env bash

eval "$(starship init bash)"
eval "$(direnv hook bash)"

fastfetch

if [ -x "$(command -v tmux)" ] && [ -z "${TMUX}" ]; then 
    tmux new-session -A -s "${USER}" >/dev/null 2>&1
fi
