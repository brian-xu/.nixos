{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dinky";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sedwards2009";
    repo = "dinky";
    rev = "v${version}";
    hash = "sha256-3xPaLKryiflOZ6zxF6X/WPwtwPAYHAJfsFGfe2cfatQ=";
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  meta = {
    description = "A simple terminal text editor with familiar GUI-style controls";
    homepage = "https://github.com/sedwards2009/dinky";
    license = lib.licenses.mit;
    mainProgram = "dinky";
    platforms = lib.platforms.linux;
  };
}
