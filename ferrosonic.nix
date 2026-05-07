{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, mpv }:

stdenv.mkDerivation rec {
  pname = "ferrosonic";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/Jamie098/ferrosonic-ng/releases/download/v${version}/ferrosonic-${version}-linux-x86_64";
    sha256 = "135nz34sz04vb6894f9gsyla6rpbi22a1s3lr81bd653543xyy87";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ mpv ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/ferrosonic
    wrapProgram $out/bin/ferrosonic \
      --prefix PATH : ${lib.makeBinPath [ mpv ]}
    runHook postInstall
  '';

  meta = {
    description = "Terminal music player";
    homepage = "https://github.com/Jamie098/ferrosonic-ng";
    platforms = [ "x86_64-linux" ];
    mainProgram = "ferrosonic";
  };
}
