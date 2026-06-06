{ pkgs, ... }:
{
  programs.niri.settings.spawn-at-startup = [
    # Provides cosmic-comp's session API so cosmic-session finishes its
    # readiness handshake and launches the panel + shell components. Without
    # this, cosmic-session blocks forever and no panel/applets appear.
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
