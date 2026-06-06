{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.allExceptThisDefault ./.;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home.packages = with pkgs; [
    swayidle
    xwayland-satellite
    grim
    gscreenshot
  ];

  xdg.portal = {
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    };
  };
}
