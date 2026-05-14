{ inputs, config, pkgs, ... }:
{
  programs.niri.enable = true;

  home.packages = with pkgs; [
    yazi
    pcmanfm
    feh
    (callPackage ../../../../pkgs/dinky.nix { })
    vlc
    okular
  ];
}
