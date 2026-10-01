{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    (aspellWithDicts (
      dicts: with dicts; [
        en
      ]
    ))
  ];
}
