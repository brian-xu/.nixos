{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-alternative-startup";
  version = "0-unstable-2024-10-26";

  src = fetchFromGitHub {
    owner = "drakulix";
    repo = "cosmic-ext-alternative-startup";
    rev = "8ceda00197c7ec0905cf1dccdc2d67d738e45417";
    hash = "sha256-0kqn3hZ58uQMl39XXF94yQS1EWmGIK45/JFTAigg/3M=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = {
    description = "Provides cosmic-comp's session API for running COSMIC shell on other compositors";
    homepage = "https://github.com/drakulix/cosmic-ext-alternative-startup";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-alternative-startup";
    platforms = lib.platforms.linux;
  };
}
