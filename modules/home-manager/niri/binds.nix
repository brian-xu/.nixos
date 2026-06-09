{
  config,
  ...
}:
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "super+Q".action = close-window;
    "super+F".action = expand-column-to-available-width;
    "super+T".action = toggle-window-floating;

    "super+L".action = spawn "loginctl" "lock-session";
    "super+Space".action = spawn "cosmic-launcher";
    "super+A".action = spawn "cosmic-app-library";
    "super+Return".action = spawn "foot";

    "super+S".action = set-column-width "-34%";
    "super+D".action = set-column-width "+34%";

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
    "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+";
    "XF86AudioPrev".action = spawn "playerctl" "previous";
    "XF86AudioPlay".action = spawn "playerctl" "play-pause";
    "XF86AudioNext".action = spawn "playerctl" "next";
    "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";
    "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "5%+";
  };
}
