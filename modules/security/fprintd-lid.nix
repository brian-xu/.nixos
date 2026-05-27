# taken from https://github.com/NixOS/nixpkgs/pull/342676

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fprintd.lid;
  lidScript = pkgs.writeShellScript "fprintd-lid-check" ''
    ${pkgs.gnugrep}/bin/grep -q closed ${cfg.path} && exit 1; true
  '';
in
{
  options.services.fprintd.lid = {
    authSkipLidClose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disable fprint auth when laptop lid is closed. Useful for docked laptops.
      '';
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "/proc/acpi/button/lid/LID/state";
      description = "Path to the lid state file.";
    };
    pamServices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        PAM service names to apply the lid-close fingerprint skip to.
        Set to any service that has fprintAuth enabled.
      '';
    };
  };

  config = lib.mkIf cfg.authSkipLidClose {
    security.pam.services = lib.genAttrs cfg.pamServices (_: {
      rules.auth.fprintd-lid = {
        order = 11399;
        control = "[success=ignore default=1]";
        modulePath = "${pkgs.linux-pam}/lib/security/pam_exec.so";
        args = [
          "quiet"
          "${lidScript}"
        ];
      };
    });
  };
}
