{ inputs }:
[
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
    kdePackages = prev.kdePackages.overrideScope (
      kfinal: kprev: {
        dolphin = (import ./dolphin.nix) prev kprev;
      }
    );
  })
]
