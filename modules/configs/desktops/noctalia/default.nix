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
    # commands
    grim
    pwvucontrol
    cliphist
    wl-clipboard
    wl-clip-persist
    # desktop apps
    (callPackage ../../../../pkgs/dinky.nix { })
    feh
    vlc
    yazi
    gscreenshot
    kdePackages.okular
    # file manager
    kdePackages.qtsvg
    kdePackages.dolphin # This is the actual dolphin package
    kdePackages.kio # needed since 25.11
    kdePackages.kio-fuse # to mount remote filesystems via FUSE
    kdePackages.kio-extras # extra protocols support (sftp, fish and more)
  ];

  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };
}
