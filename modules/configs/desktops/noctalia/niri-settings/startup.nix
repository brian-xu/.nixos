{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ "noctalia" ]; }
    {
      command = [
        "systemctl"
        "--user"
        "start"
        "hyprpolkitagent"
      ];
    }
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
        "noctalia msg screen-lock"
      ];
    }
  ];
}
