{ inputs }:
[
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };

    cosmic-ext-alternative-startup = final.callPackage ../pkgs/cosmic-ext-alternative-startup.nix { };
  })
]
