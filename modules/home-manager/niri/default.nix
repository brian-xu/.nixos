{
  pkgs,
  lib,
  inputs,
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
    wl-clipboard
    inputs.latchshot.packages.${pkgs.system}.default
  ];

  xdg.desktopEntries.latchshot = {
    name = "Latchshot";
    genericName = "Screenshot";
    comment = "A lightweight yet intelligent window-aware screenshot tool for Wayland";
    exec = "latchshot";
    icon = "applets-screenshooter";
    terminal = false;
    categories = [
      "Utility"
      "Graphics"
    ];
    settings.Keywords = "screenshot;capture;screen;";
  };

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
