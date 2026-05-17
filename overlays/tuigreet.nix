final: prev:
prev.tuigreet.overrideAttrs (old: rec {
  src = prev.fetchFromGitHub {
    owner = "NotAShelf";
    repo = "tuigreet";
    tag = "0.10.2";
    hash = "sha256-jeelrp9r/V8540qKoCofD8wz/w/qBcubs72HkremhME=";
  };

  cargoDeps = final.rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-B5Qxwv8jdpGJwXTEm5c12kvb6fri7H1AL2w640xQXVQ=";
  };
})
