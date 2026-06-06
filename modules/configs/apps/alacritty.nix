{
  # Overwrite an existing on-disk alacritty.toml in place rather than backing it
  # up, so a stale .bak can't block home-manager activation.
  xdg.configFile."alacritty/alacritty.toml".force = true;

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    env.TERM = "xterm-256color";
    font.normal.family = "FiraCode Nerd Font";

    terminal.shell = {
      program = "zsh";
      args = [
        "-c"
        "krabby random && exec zsh"
      ];
    };

    keyboard.bindings = [
      {
        key = "N";
        mods = "Control";
        action = "SpawnNewInstance";
      }
      {
        key = "Q";
        mods = "Control";
        action = "Quit";
      }
      {
        key = "C";
        mods = "Control|Shift";
        action = "Copy";
      }
      {
        key = "V";
        mods = "Control";
        action = "Paste";
      }
    ];

    cursor = {
      style = {
        shape = "beam";
        blinking = "always";
      };
    };

    window = {
      decorations = "buttonless";
      dynamic_padding = false;
      opacity = 1.0;
      option_as_alt = "Both";

      padding = {
        x = 25;
        y = 20;
      };
    };
  };
}
