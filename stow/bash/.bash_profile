export EDITOR=$(command -v nvim || command -v vim)
export SHELL="$(command -v bash)"

# Homebrew
export HOMEBREW_PREFIX="$HOME/.brew"
export PATH="$HOMEBREW_PREFIX/bin:$PATH"

. ~/.bashrc
