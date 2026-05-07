{ config, pkgs, ... }:

let
  plasma-manager = builtins.fetchTarball "https://github.com/nix-community/plasma-manager/archive/trunk.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
in

{
  imports = [
    "${home-manager}/nixos"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [ (import "${plasma-manager}/modules") ];

  home-manager.users.brian =
    { pkgs, ... }:
    {
      imports = [ ./alacritty.nix ];

      programs.bash.enable = true;
      programs.plasma.enable = true;
      home.packages = with pkgs; [
        (callPackage ./ferrosonic.nix { })
        # util
        sops
        age
        ssh-to-age
        pkg-config
        nixfmt
        nerd-fonts.fira-code
        # desktop apps
        bitwarden-desktop
        floorp-bin
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

      programs.plasma.krunner.shortcuts.launch = "Ctrl+Space";

      home.stateVersion = "25.11"; # Please read the comment before changing.
    };
}
