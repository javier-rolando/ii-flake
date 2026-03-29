# elecwhat — cliente de escritorio WhatsApp para Linux (buildNpmPackage)
{ lib, buildNpmPackage, fetchFromGitHub, electron_38, makeWrapper }:

buildNpmPackage {
  pname = "elecwhat";
  version = "1.13.4";

  src = fetchFromGitHub {
    owner = "piec";
    repo  = "elecwhat";
    rev   = "v1.13.4";
    hash  = "sha256-jBSKnZ8q612jYOKe5rsccrcMpmPYQp9mKK64GyyqZCk=";
  };

  npmDepsHash = lib.fakeHash;
  npmDepsFetcherVersion = 2;

  # No usar electron-builder (usamos el electron de nixpkgs)
  # --ignore-scripts omite el postinstall "electron-builder install-app-deps"
  npmInstallFlags = [ "--ignore-scripts" ];

  # No hay paso de build JS que ejecutar
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/elecwhat
    cp -r src src-web static locales package.json node_modules $out/lib/elecwhat/

    install -Dm644 static/app-512.png \
      $out/share/icons/hicolor/512x512/apps/elecwhat.png

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

    mkdir -p $out/bin
    makeWrapper ${electron_38}/bin/electron $out/bin/elecwhat \
      --add-flags "$out/lib/elecwhat" \
      --add-flags "--no-sandbox"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple desktop WhatsApp client for Linux";
    homepage    = "https://github.com/piec/elecwhat";
    license     = licenses.gpl3;
    platforms   = [ "x86_64-linux" ];
    mainProgram = "elecwhat";
  };
}
