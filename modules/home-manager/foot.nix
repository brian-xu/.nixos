{
  programs.foot.enable = true;
  programs.foot.settings = {
    main = {
      term = "xterm-256color";
      font = "Inconsolata Nerd Font:size=12";
      pad = "25x20";
      shell = ''bash -c "krabby random && exec bash"'';
    };

    cursor = {
      style = "beam";
      blink = "yes";
    };

    key-bindings = {
      spawn-terminal = "Control+n";
      clipboard-copy = "Control+Shift+c XF86Copy";
      clipboard-paste = "Control+v Control+Shift+v XF86Paste";
    };
  };
}
