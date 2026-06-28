{ inputs }:
[
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };

    cosmic-ext-alternative-startup = final.callPackage ../pkgs/cosmic-ext-alternative-startup.nix { };

    openblas =
      if prev.stdenv.hostPlatform.isi686 then
        prev.openblas.overrideAttrs (_: {
          doCheck = false;
        })
      else
        prev.openblas;
  })
]
