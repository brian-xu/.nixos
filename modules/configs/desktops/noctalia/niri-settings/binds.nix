{
  config,
  pkgs,
  ...
}:

let

  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "super+Q".action = close-window;
    "super+F".action = maximize-window-to-edges;
    "super+T".action = toggle-window-floating;

    "super+L".action.spawn = noctalia "lockScreen lock";
    "super+Space".action.spawn = noctalia "launcher toggle";
    "super+Return".action = spawn "alacritty";

    "super+S".action = set-column-width "-33%";
    "super+D".action = set-column-width "+33%";

    "super+WheelScrollDown" = {
      action = focus-column-right;
      cooldown-ms = 150;
    };
    "super+WheelScrollUp" = {
      action = focus-column-left;
      cooldown-ms = 150;
    };
    "super+Shift+WheelScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 150;
    };
    "super+Shift+WheelScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 150;
    };

    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-workspace-down;
    "super+Up".action = focus-workspace-up;

    "super+Shift+Left".action = move-column-left;
    "super+Shift+Right".action = move-column-right;
    "super+Shift+Down".action = move-column-to-workspace-down;
    "super+Shift+Up".action = move-column-to-workspace-up;

    # multimedia keys
    "XF86AudioMute".action.spawn = noctalia "volume muteOutput"; # output mute
    "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease"; # output decrease
    "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase"; # output increase
    "XF86AudioPrev".action.spawn = noctalia "media previous";
    "XF86AudioPlay".action.spawn = noctalia "media playPause";
    "XF86AudioNext".action.spawn = noctalia "media next";
    "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";
    "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
  };
}
