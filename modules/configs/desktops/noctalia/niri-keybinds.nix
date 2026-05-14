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
    "super+q".action = close-window;
    "super+f".action = fullscreen-window;
    "super+t".action = toggle-window-floating;

    "super+L".action.spawn = noctalia "lockScreen lock";
    "super+Space".action.spawn = noctalia "launcher toggle";

    "super+WheelScrollDown".action = focus-column-right;
    "super+WheelScrollUp".action = focus-column-left;

    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-workspace-down;
    "super+Up".action = focus-workspace-up;

    "super+Shift+Left".action = move-column-left;
    "super+Shift+Right".action = move-column-right;
    "super+Shift+Down".action = move-column-to-workspace-down;
    "super+Shift+Up".action = move-column-to-workspace-up;
  };
}
