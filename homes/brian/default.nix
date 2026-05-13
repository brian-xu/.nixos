{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/configs/apps
    ../../modules/configs/desktops/plasma
  ];

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    # util
    sops
    age
    ssh-to-age
    pkg-config
    nixfmt
    nerd-fonts.fira-code
    ffmpeg
    # desktop apps
    (pkgs.callPackage ../../pkgs/ferrosonic.nix { })
    bitwarden-desktop
    slack
    discord
    obsidian
    thunderbird
    # coding
    git
    uv
    ruff
    alacritty
    vscode-fhs
    claude-code
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brian Xu";
        email = "brian@brian-xu.com";
      };
    };
    extraConfig.push.autoSetupRemote = true;
  };

  home.stateVersion = "25.11"; # Please read the comment before changing.
}
