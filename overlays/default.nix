{ inputs }:
[
  (final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
    nautilus = prev.nautilus.overrideAttrs (nprev: {
      buildInputs =
        nprev.buildInputs
        ++ (with prev.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
          gst-libav
        ]);
    });
  })
]
