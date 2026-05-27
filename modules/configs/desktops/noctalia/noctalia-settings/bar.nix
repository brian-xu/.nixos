{
  programs.noctalia.settings.bar = {
    default = {
      center = [ "workspaces" ];
      end = [
        "tray"
        "notifications"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "control-center"
        "clock"
        "session"
      ];
      start = [
        "launcher"
        "wallpaper"
        "media"
      ];
    };
  };
}
