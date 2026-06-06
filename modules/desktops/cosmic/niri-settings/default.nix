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
}
