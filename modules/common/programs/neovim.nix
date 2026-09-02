{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.neovim-unwrapped.overrideAttrs {
      doInstallCheck = false;
      src = inputs.neovim;
    })
  ];

  preferences = {
    editor = "nvim";
    manpager = "nvim +Man!";
  };
}
