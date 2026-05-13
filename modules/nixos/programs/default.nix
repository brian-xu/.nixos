{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    micromamba
    nixd
  ];
  environment.shellAliases = {
    conda = "micromamba";
    nixos-rebuild = "nixos-rebuild --flake ~/.nixos#nixos";
  };
  environment.sessionVariables = {
    MAMBA_ROOT_PREFIX = "/home/brian/.micromamba";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.plugins = [ "git" ];
    ohMyZsh.theme = "frisk";
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      mkdir -p $MAMBA_ROOT_PREFIX
      eval "$(micromamba shell hook -s zsh)"
    '';
  };

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.defaultUserShell = pkgs.zsh;
}
