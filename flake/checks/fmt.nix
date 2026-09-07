{
  git,
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
      self.formatter.${stdenv.hostPlatform.system}
    ];
  }
  ''
    set -euo pipefail

    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null
    export GIT_ATTR_NOSYSTEM=1

    worktree="$TMPDIR/src"
    cp -R "${self}/." "$worktree"
    chmod -R u+w "$worktree"
    cd "$worktree"

    git init -q
    git config user.name Nix
    git config user.email nix@localhost
    git add -A
    git commit -qm init

    treefmt --version
    printf ' '
    treefmt --no-cache

    git diff --exit-code

    touch "$out"
  ''
