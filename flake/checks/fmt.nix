{
  git,
  git-lfs,
  runCommandLocal,
  self,
  stdenv,
}:

runCommandLocal "fmt-check"
  {
    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      git
      git-lfs
      self.formatter.${stdenv.hostPlatform.system}
    ];
  }
  ''
    set -euo pipefail

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    git config --global user.name Nix
    git config --global user.email nix@localhost
    git config --global init.defaultBranch main

    worktree="$TMPDIR/project"
    cp -r "${self}" "$worktree"
    chmod -R u+w "$worktree"
    cd "$worktree"

    git init --quiet
    git add -A
    git commit -m init --quiet

    treefmt --version 
    printf ' '
    treefmt --no-cache

    git status --short
    git --no-pager diff --exit-code

    touch "$out"
  ''
