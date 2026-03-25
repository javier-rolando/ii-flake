# Readex Pro — ttf-readex-pro (no disponible como nixpkg estándar)
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "readex-pro";
  version = "unstable-2022-09-25";

  src = fetchFromGitHub {
    owner = "ThomasJockin";
    repo  = "readexpro";
    rev   = "master";
    hash  = "sha256-3jpPDk6WuLfw53S7dBH0d5/KAeG3mnR9349A7QprOts=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 fonts/ttf/*.ttf -t $out/share/fonts/TTF
    install -Dm444 fonts/variable/*.ttf -t $out/share/fonts/TTF
    runHook postInstall
  '';

  meta = {
    description = "Readex Pro — fuente variable diseñada para máxima legibilidad";
    homepage    = "https://fonts.google.com/specimen/Readex+Pro";
    license     = lib.licenses.ofl;
    platforms   = lib.platforms.all;
  };
}
