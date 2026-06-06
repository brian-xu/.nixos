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
}
