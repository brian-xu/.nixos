# ly taken from https://github.com/neonvoidx/nix/blob/master/modules/security/ly.nix

{
  pkgs,
  ...
}:
{
  services.greetd.enable = true;
  services.sysc-greet = {
    enable = true;
    compositor = "niri";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.printing.enable = true;
  services.tailscale.enable = true;
}
