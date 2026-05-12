{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../modules/home/apps/alacritty
    ../../../modules/home/apps/firefox
    ../../../modules/home/desktop/plasma
  ];

  home.packages = with pkgs; [
    (pkgs.callPackage ../../../packages/ferrosonic { })
    # util
    sops
    age
    ssh-to-age
    pkg-config
    nixfmt
    nerd-fonts.fira-code
    ffmpeg
    # desktop apps
    bitwarden-desktop
    bitwarden-cli
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
