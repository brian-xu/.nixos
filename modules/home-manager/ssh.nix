{
  osConfig,
  config,
  lib,
  ...
}:

let
  inherit (import ../ssh-hosts.nix) hostsTemplate;

  hasHostsTemplate = (osConfig.sops ? templates) && (osConfig.sops.templates ? ${hostsTemplate});
in
{
  home.file.".ssh/config" = lib.optionalAttrs hasHostsTemplate {
    source = config.lib.file.mkOutOfStoreSymlink osConfig.sops.templates.${hostsTemplate}.path;
  };
}
