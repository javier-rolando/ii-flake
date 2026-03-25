# Space Grotesk — otf-space-grotesk (no disponible como nixpkg estándar)
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "space-grotesk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "floriankarsten";
    repo  = "space-grotesk";
    rev   = "v1.0.1";
    hash  = "sha256-NKV6A4opImEUmnsxQtcc+f/su6UvQoq3q3hBt3Y50+Y=";
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
