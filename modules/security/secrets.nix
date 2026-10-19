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

  hostsConf = lib.concatStrings (
    lib.mapAttrsToList (
      _: host:
      lib.optionalString (host ? ipSecret) ''
        Host ${host.alias}
          HostName ${config.sops.placeholder.${host.ipSecret}}
      ''
    ) hosts
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
