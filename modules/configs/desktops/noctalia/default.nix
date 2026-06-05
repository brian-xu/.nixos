{
  pkgs,
  lib,
  ...
}:
{
  imports = lib.allExceptThisDefault ./.;

  programs.noctalia.enable = true;
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home.packages = with pkgs; [
    # daemons
    udiskie
    swayidle
    xwayland-satellite
    # commands
    grim
    pwvucontrol
    cliphist
    wl-clipboard
    wl-clip-persist
    # desktop apps
    gscreenshot
    kdePackages.okular
    kdePackages.gwenview
    gedit
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
