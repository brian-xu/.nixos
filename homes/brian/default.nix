{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/configs/apps
    ../../modules/desktops/cosmic/niri-settings
  ];

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    # util
    pkg-config
    nixfmt
    nerd-fonts.fira-code
    ffmpeg
    krabby
    # desktop apps
    (callPackage ../../pkgs/dinky.nix { })
    inputs.subtui.packages.${pkgs.system}.subtui
    mpv
    bitwarden-cli
    slack
    vesktop
    obsidian
    thunderbird
    blender
    # coding
    uv
    ruff
    pkgs.unstable.vscode.fhs
    pkgs.unstable.claude-code
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

  home.stateVersion = "26.05"; # Please read the comment before changing.
}
