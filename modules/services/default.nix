# ly taken from https://github.com/neonvoidx/nix/blob/master/modules/security/ly.nix

{
  pkgs,
  ...
}:
{
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "gameoflife";
      asterisk = "0x2022";
      bigclock = "en";
      bigclock_seconds = true;
      clear_password = false;
      bg = "0x00212337";
      border_fg = "0x00a48cf2";
      error_bg = "0x00212337";
      error_fg = "0x01f16c75";
      fg = "0x0039ddfd";
      cmatrix_fg = "0x0037f499";
      gameoflife_fg = "0x0037f499";
      cmatrix_head_col = "0x01ffffff";
      default_input = "password";
    };
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
