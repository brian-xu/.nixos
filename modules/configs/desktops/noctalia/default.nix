{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.allExceptThisDefault ./.;

  programs.noctalia-shell.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings.hotkey-overlay.skip-at-startup = true;
  };

  home.packages = with pkgs; [
    # daemons
    udiskie
    swayidle
    xwayland-satellite
    # commands
    grim
    pwvucontrol
    cliphist
    wl-clipboard
    wl-clip-persist
    # desktop apps
    (callPackage ../../../../pkgs/dinky.nix { })
    feh
    vlc
    yazi
    xfce.thunar
    gscreenshot
    kdePackages.okular
  ];
}
