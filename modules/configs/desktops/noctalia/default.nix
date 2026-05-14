{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
  ] ++ lib.allExceptThisDefault ./. ;

  programs.noctalia-shell.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings.hotkey-overlay.skip-at-startup = false; # true;
  };

  home.packages = with pkgs; [
    yazi
    pcmanfm
    feh
    (callPackage ../../../../pkgs/dinky.nix { })
    vlc
    kdePackages.okular
    xwayland-satellite
  ];
}
