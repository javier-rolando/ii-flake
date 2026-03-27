# Space Grotesk — otf-space-grotesk (no disponible como nixpkg estándar)
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "space-grotesk";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "floriankarsten";
    repo  = "space-grotesk";
    rev   = "2.0.0";
    hash  = "sha256-frHmgB3CU+YACIMj0kdeAwrUoVAOZL2xj80fmoHdMao=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 fonts/otf/*.otf -t $out/share/fonts/OTF
    runHook postInstall
  '';

  meta = {
    description = "Space Grotesk — fuente sans-serif variable (Google Fonts)";
    homepage    = "https://fonts.google.com/specimen/Space+Grotesk";
    license     = lib.licenses.ofl;
    platforms   = lib.platforms.all;
  };
}
