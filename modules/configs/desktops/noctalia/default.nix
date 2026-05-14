{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    yazi
    pcmanfm
    feh
    (callPackage ../../../../pkgs/dinky.nix { })
    vlc
    kdePackages.okular
  ];
}
