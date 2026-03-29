# elecwhat — cliente de escritorio WhatsApp para Linux
{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper,
  alsa-lib, atk, at-spi2-atk, at-spi2-core, cairo, cups,
  dbus, expat, gtk3, libX11, libXcomposite, libXdamage,
  libXext, libXfixes, libXrandr, libxcb, libxkbcommon,
  mesa, nss, pango, systemd,
}:

let
  version = "1.13.4";
  icon = fetchurl {
    url  = "https://raw.githubusercontent.com/piec/elecwhat/v${version}/static/app-512.png";
    hash = "sha256-l55WL01Dej3LrARgTh0vXhHvKuY9p1A8Ztw3jHvKB4Y=";
  };
in
stdenv.mkDerivation {
  pname = "elecwhat";
  inherit version;

  src = fetchurl {
    url  = "https://github.com/piec/elecwhat/releases/download/v${version}/elecwhat-${version}.tar.xz";
    hash = "sha256-U8XqHJwT+294asALH1N3KDFqjbXfUEnEcHU4gL1uTRk=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    alsa-lib atk at-spi2-atk at-spi2-core cairo cups
    dbus expat gtk3 libX11 libXcomposite libXdamage
    libXext libXfixes libXrandr libxcb libxkbcommon
    mesa nss pango systemd
    stdenv.cc.cc.lib
  ];

  # Las libs musl en sharp son para arquitectura musl (no usadas en glibc x86_64)
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  dontBuild  = true;
  dontStrip  = true;
  sourceRoot = "elecwhat-${version}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/elecwhat
    cp -r . $out/lib/elecwhat/

    # Wrapper con --no-sandbox (requerido para Electron sin setuid sandbox en NixOS)
    mkdir -p $out/bin
    makeWrapper $out/lib/elecwhat/elecwhat $out/bin/elecwhat \
      --add-flags "--no-sandbox"

    # Icono
    install -Dm644 ${icon} $out/share/icons/hicolor/512x512/apps/elecwhat.png

    # Entrada de escritorio
    mkdir -p $out/share/applications
    cat > $out/share/applications/elecwhat.desktop <<EOF
[Desktop Entry]
Name=ElecWhat
Comment=Simple desktop WhatsApp client
Exec=elecwhat
Icon=elecwhat
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
StartupWMClass=elecwhat
StartupNotify=true
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple desktop WhatsApp client for Linux";
    homepage    = "https://github.com/piec/elecwhat";
    license     = licenses.gpl3;
    platforms   = [ "x86_64-linux" ];
    mainProgram = "elecwhat";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
