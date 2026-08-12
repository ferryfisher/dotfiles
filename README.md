<div align="center">

# dotfiles

</div>

## Installation

> [!note]
>
> Clone this repository to `~/dotfiles`.
>
> Run `stow` for each config in [stow](stow/) or `stow *` for every config.

dotfiles managed via [GNU Stow](https://www.gnu.org/software/stow/).

> [!warning]
> The schemas flake output currently only works with [Determinate Nix](https://github.com/DeterminateSystems/nix-installer)

## Formatting

`nix fmt` formats the repository and `nix flake check` runs flake tests
(including formatting checks).
