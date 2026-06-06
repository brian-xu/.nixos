{
  pkgs,
  ...
}:
{
  programs.niri.settings.spawn-at-startup = [
    {
      command = [ "${pkgs.cosmic-ext-alternative-startup}/bin/cosmic-ext-alternative-startup" ];
    }
    { command = [ "xwayland-satellite" ]; }
    {
      command = [
        "wl-clip-persist"
        "--clipboard"
        "both"
      ];
    }
    {
      command = [
        "sh"
        "-c"
        "wl-paste --type text --watch cliphist store"
      ];
    }
    {
      command = [
        "sh"
        "-c"
        "wl-paste --type image --watch cliphist store"
      ];
    }
  ];
}
