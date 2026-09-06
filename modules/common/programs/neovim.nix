{
  inputs,
  pkgs,
  self,
  ...
}:

let
  lock = builtins.fromJSON (builtins.readFile (self + "/.tack/pins.lock.json"));
  rev = builtins.substring 0 12 lock.neovim.rev;
in
{
  environment.systemPackages = [
    (pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: {
      src = inputs.neovim;
      version = rev;

      postPatch = ''
        ${oldAttrs.postPatch or ""}

        substituteInPlace cmake.config/versiondef.h.in --replace-fail \
        '@NVIM_VERSION_PRERELEASE@' '-nightly+${rev}'
      '';
    }))
  ];

  preferences = {
    editor = "nvim";
    manpager = "nvim +Man!";
  };
}
