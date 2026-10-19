{
  osConfig,
  lib,
  ...
}:

let
  inherit (import ../ssh-hosts.nix) hostsTemplate identities hosts;

  settingsFor =
    host:
    {
      User = host.user;
    }
    // lib.optionalAttrs (host ? port) { Port = host.port; }
    // lib.optionalAttrs (host ? hostName) { HostName = host.hostName; }
    // lib.optionalAttrs (host ? hostKeyAlias) { HostKeyAlias = host.hostKeyAlias; }
    // lib.optionalAttrs (host ? identity) {
      IdentityFile = "~/.ssh/${identities.${host.identity}}";
    }
    // lib.optionalAttrs (host ? identitiesOnly) {
      IdentitiesOnly = host.identitiesOnly;
    }
    // lib.optionalAttrs (host ? checkHostIP) { CheckHostIP = host.checkHostIP; };

  hasHostsTemplate = (osConfig.sops ? templates) && (osConfig.sops.templates ? ${hostsTemplate});
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.optionals hasHostsTemplate [
      osConfig.sops.templates.${hostsTemplate}.path
    ];
    settings = lib.mapAttrs' (_: host: lib.nameValuePair host.alias (settingsFor host)) hosts;
  };
}
