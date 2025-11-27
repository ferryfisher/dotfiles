# Silence MacOS zsh terminal warning on startup
export BASH_SILENCE_DEPRECATION_WARNING=1

# Homebrew
export HOMEBREW_PREFIX=~/.brew
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

. ~/.bashrc
. "$HOME/.cargo/env"
