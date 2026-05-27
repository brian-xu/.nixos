{
  lib,
  ...
}:
{

  imports = lib.allExceptThisDefault ./.;
  programs.noctalia.settings = {
    nightlight.enabled = true;
    weather = {
      address = "Providence, US";
      unit = "imperial";
    };
  };
}
