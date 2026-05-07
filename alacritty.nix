{
  config,
  lib,
  pkgs,
  ...
}:
let
  themes = (
    fetchTarball "https://github.com/alacritty/alacritty-theme/archive/40e0c6c8690d1c62f58718fcef8a48eb6077740b.tar.gz"
  );
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
