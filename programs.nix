{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    ohMyZsh.theme = "frisk";
    syntaxHighlighting.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
}
