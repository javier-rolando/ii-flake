# Space Grotesk — otf-space-grotesk (no disponible como nixpkg estándar)
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "space-grotesk";
  version = "3.0.1";

  # NOTA: Si el hash falla, ejecuta:
  #   nix-prefetch-github floriankarsten space-grotesk --rev v3.0.1
  src = fetchFromGitHub {
    owner = "floriankarsten";
    repo  = "space-grotesk";
    rev   = "v3.0.1";
    hash  = lib.fakeHash;  # Reemplaza con el hash real (ver NOTA arriba)
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 fonts/ttf/*.ttf -t $out/share/fonts/TTF
    runHook postInstall
  '';

  meta = {
    description = "Space Grotesk — fuente sans-serif variable (Google Fonts)";
    homepage    = "https://fonts.google.com/specimen/Space+Grotesk";
    license     = lib.licenses.ofl;
    platforms   = lib.platforms.all;
  };
}
