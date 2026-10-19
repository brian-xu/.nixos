{
  osConfig,
  lib,
  ...
}:

let
  # secrets.nix only defines the sops template when the age key exists;
  # fall back to an empty file so SSH config evaluation never breaks on a
  # key-less fresh install.
  sshHostsConf = (
    if (osConfig.sops ? templates) && (osConfig.sops.templates ? "ssh-hosts.conf") then
      osConfig.sops.templates."ssh-hosts.conf".path
    else
      "/dev/null"
  );
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ sshHostsConf ];
    settings = {
      "discord.us-central1-a.cloud-computation-136" = {
        User = "brianxu";
        IdentityFile = "~/.ssh/google_compute_engine";
        IdentitiesOnly = "yes";
        CheckHostIP = "no";
      };
      racknerd = {
        User = "root";
        Port = "48484";
        IdentityFile = "~/.ssh/racknerd";
      };
      debian = {
        User = "bob";
      };
      "github.com" = {
        HostName = "ssh.github.com";
        Port = "443";
        User = "git";
        HostKeyAlias = "github.com";
      };
    };
  };
}
