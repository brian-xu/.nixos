{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./mime-apps.nix
    ../../modules/home-manager
  ];

  programs.firefox.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # util
    pkg-config
    nixfmt
    nerd-fonts.fira-code
    ffmpeg
    krabby
    bubblemail
    # desktop apps
    inputs.subtui.packages.${pkgs.system}.subtui
    mpv
    vesktop
    obsidian
    evolution
    godot
    bitwarden-desktop
    # coding
    uv
    ruff
    prek
    terraform
    just
    nodejs_22
    pkgs.unstable.mistral-vibe
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Brian Xu";
        email = "brian@brian-xu.com";
      };
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    extraConfig.push.autoSetupRemote = true;
  };

  home.stateVersion = "26.05"; # Please read the comment before changing.
}
