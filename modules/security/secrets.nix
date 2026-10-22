{
  config,
  lib,
  ...
}:

let
  inherit (import ../ssh-hosts.nix)
    user
    hostsTemplate
    identities
    hosts
    ;

  identitySecrets = lib.mapAttrs (secret: basename: {
    path = "${config.users.users.${user}.home}/.ssh/${basename}";
    owner = user;
    mode = "600";
  }) identities;

  ipSecrets = lib.mapAttrs' (
    _: host: lib.nameValuePair host.ipSecret { sopsFile = ../../secrets/ssh-ips.yaml; }
  ) (lib.filterAttrs (_: host: host ? ipSecret) hosts);

  settingsFor =
    host:
    {
      User = host.user;
    }
    // lib.optionalAttrs (host ? ipSecret) {
      HostName = config.sops.placeholder.${host.ipSecret};
    }
    // lib.optionalAttrs (host ? hostName) { HostName = host.hostName; }
    // lib.optionalAttrs (host ? port) { Port = host.port; }
    // lib.optionalAttrs (host ? hostKeyAlias) { HostKeyAlias = host.hostKeyAlias; }
    // lib.optionalAttrs (host ? identity) {
      IdentityFile = "~/.ssh/${identities.${host.identity}}";
    }
    // lib.optionalAttrs (host ? identitiesOnly) { IdentitiesOnly = host.identitiesOnly; }
    // lib.optionalAttrs (host ? checkHostIP) { CheckHostIP = host.checkHostIP; };

  hostsConf = lib.concatStrings (
    lib.mapAttrsToList (_: host: ''
      Host ${host.alias}
      ${lib.concatStrings (lib.mapAttrsToList (k: v: "  ${k} ${v}\n") (settingsFor host))}
    '') hosts
  );
in
{
  sops.defaultSopsFile = ../../secrets/secrets.yaml;

  sops.secrets = identitySecrets // ipSecrets;

  sops.templates = {
    ${hostsTemplate} = {
      owner = user;
      content = hostsConf;
    };
  };

  sops.useSystemdActivation = true;
  systemd.services.sops-install-secrets.unitConfig.ConditionPathExists = [
    config.sops.age.keyFile
  ];
}
