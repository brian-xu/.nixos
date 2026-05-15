{
  lib,
  ...
}:
{
  imports = lib.allExceptThisDefault ./.;
  programs.noctalia-shell.settings.settingsVersion = 59;
}
