{
  inputs,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    yazi
    pcmanfm
    feh
    (callPackage ../../../../pkgs/dinky.nix { })
    vlc
    kdePackages.okular
  ];
}
