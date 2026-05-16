{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ "noctalia-shell" ]; }
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
    {
      command = [
        "swayidle"
        "before-sleep"
        "hyprlock"
      ];
    }
  ];
}
