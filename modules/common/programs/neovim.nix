{ inputs', ... }:

{
  environment = {
    systemPackages = [
      inputs'.neovim-nightly-overlay.packages.neovim
    ];
  };

  preferences = {
    editor = "nvim";
    manpager = "nvim +Man!";
  };
}
