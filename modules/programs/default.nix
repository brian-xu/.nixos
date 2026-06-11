{
  pkgs,
  ...
}:
let
  micromamba-unwrapped = pkgs.runCommand "micromamba-unwrapped" { } ''
    install -Dm755 ${pkgs.mamba-cpp}/bin/.mamba-wrapped $out/bin/micromamba
  '';

  micromamba-fhs = pkgs.buildFHSEnv {
    name = "micromamba";
    targetPkgs = _: [ micromamba-unwrapped ];
    runScript = "micromamba";
    profile = ''
      set -e
      export MAMBA_ROOT_PREFIX=$HOME/.micromamba
      eval "$(micromamba shell hook --shell=posix)"
      set +e
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    micromamba-fhs
    nixd
    fastfetch
  ];
  environment.shellAliases.conda = "micromamba";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/brian/.nixos";
  };

  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
