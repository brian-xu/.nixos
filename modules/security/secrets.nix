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

  hasAgeKey = builtins.pathExists config.sops.age.keyFile;

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

  sops.secrets = lib.mkIf hasAgeKey (identitySecrets // ipSecrets);

  sops.templates = lib.mkIf hasAgeKey {
    ${hostsTemplate} = {
      owner = user;
      content = hostsConf;
    };
  };
}
