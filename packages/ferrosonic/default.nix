{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  dbus,
  mpv,
  pipewire,
  wireplumber,
  cava,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "ferrosonic";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Jamie098";
    repo = "ferrosonic-ng";
    rev = "v${version}";
    hash = "sha256-AmSZkxQ12SFo8hHfHi7eXr+LF6Z8TCajA1hr9S+ivjk=";
  };

  cargoHash = "sha256-NhB6ztyveC73oCwYRCfuuvazl3gYavB7igrRBrhRi9c=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    dbus
    mpv
    pipewire
    wireplumber
  ];

  postInstall = ''
    wrapProgram $out/bin/ferrosonic \
      --prefix PATH : ${
        lib.makeBinPath [
          mpv
          cava
        ]
      }
  '';

  meta = {
    description = "Terminal music player";
    homepage = "https://github.com/Jamie098/ferrosonic-ng";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ferrosonic";
  };
}
