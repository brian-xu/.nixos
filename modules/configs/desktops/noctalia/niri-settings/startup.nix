{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ "noctalia-shell" ]; }
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
        "noctalia-shell ipc call lockScreen lock"
      ];
    }
  ];
}
