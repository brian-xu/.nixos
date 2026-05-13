{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home/apps/alacritty.nix
    ../../modules/home/apps/firefox.nix
    ../../modules/home/desktops/plasma
  ];

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

  home.stateVersion = "25.11"; # Please read the comment before changing.
}
