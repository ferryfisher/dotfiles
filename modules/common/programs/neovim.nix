{ inputs, pkgs, ... }:

let
  rev = builtins.substring 0 12 inputs._meta.neovim.rev;
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
