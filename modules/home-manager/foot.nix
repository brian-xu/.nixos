{
  programs.foot.enable = true;
  programs.foot.settings = {
    main = {
      term = "xterm-256color";
      font = "FiraCode Nerd Font:size=11";
      pad = "25x20";
      shell = ''zsh -c "krabby random && exec zsh"'';
    };

    cursor = {
      style = "beam";
      blink = "yes";
    };

    key-bindings = {
      spawn-terminal = "Control+n";
      clipboard-copy = "Control+Shift+c";
      clipboard-paste = "Control+v";
    };
  };
}
