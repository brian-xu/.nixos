{
  config,
  lib,
  pkgs,
  ...
}:
let
  themes = pkgs.fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "40e0c6c8690d1c62f58718fcef8a48eb6077740b";
    sha256 = "0bj46gf4q84rd9hj31ba5nkkc6lpljh1k7vks2h4ckx144wrvcs7";
  };
in
{
  xdg.configFile."alacritty/alacritty.toml".text = ''

    [general]
    import = [
      "${themes}/themes/kanagawa_wave.toml"
    ]

    [env]
    TERM = "xterm-256color"

    [font.normal]
    family = "FiraCode Nerd Font"

    [keyboard]
    bindings = [
      { key = "N", mods = "Control", action = "SpawnNewInstance" },
      { key = "Q", mods = "Control", action = "Quit" },
      { key = "W", mods = "Control", action = "Quit" },
      { key = "C", mods = "Control | Shift", action = "Copy" },
      { key = "V", mods = "Control", action = "Paste" }
    ]

    [cursor]
    style = {shape = "beam", blinking = "always"}

    [window]
    decorations = "buttonless"
    dynamic_padding = false
    opacity = 0.8
    option_as_alt = "Both"

    [window.padding]
    x = 25
    y = 20
  '';
}
