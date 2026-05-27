{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.allExceptThisDefault ./.;

  programs.noctalia-shell.enable = true;
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home.packages = with pkgs; [
    # daemons
    udiskie
    swayidle
    xwayland-satellite
    hyprpolkitagent
    # commands
    grim
    pwvucontrol
    cliphist
    wl-clipboard
    wl-clip-persist
    # desktop apps
    (callPackage ../../../../pkgs/dinky.nix { })
    vlc
    gscreenshot
    kdePackages.okular
    kdePackages.gwenview
    # file manager
    nautilus
  ];

  home.file."wallpapers/nix-wallpaper-nineish.png".source =
    "${pkgs.nixos-artwork.wallpapers.nineish}/share/backgrounds/nixos/nix-wallpaper-nineish.png";

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.nautilus}/bin/nautilus";
      };
    };
  };
}
