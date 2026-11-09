{ inputs }:
[
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
      overlays = [
        (_: usuper: {
          mistral-vibe = usuper.mistral-vibe.overridePythonAttrs (old: {
            doCheck = false;
            passthru = old.passthru // {
              vibe-rs = old.passthru.vibe-rs.overrideAttrs (vibeOld: {
                buildInputs = vibeOld.buildInputs ++ [ usuper.aws-lc ];
              });
            };
          });
        })
      ];
    };

    cosmic-ext-alternative-startup = final.callPackage ../pkgs/cosmic-ext-alternative-startup.nix { };
  })
]
