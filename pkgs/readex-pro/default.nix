# Readex Pro — ttf-readex-pro (no disponible como nixpkg estándar)
#
# NOTA: Si el build falla con "hash mismatch", actualiza el hash ejecutando:
#   nix-prefetch-github ThomasJockin readexpro --rev main
# o usa "--accept-flake-config" con "--extra-sandbox-paths" en el primer build.
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "readex-pro";
  version = "unstable-2022-09-25";

  src = fetchFromGitHub {
    owner = "ThomasJockin";
    repo  = "readexpro";
    rev   = "main";
    hash  = lib.fakeHash;  # Reemplaza con el hash real (ver NOTA arriba)
  };

  installPhase = ''
    runHook preInstall
    find . -name "*.ttf" -exec install -Dm444 {} $out/share/fonts/TTF/ \;
    runHook postInstall
  '';

  meta = {
    description = "Readex Pro — fuente variable diseñada para máxima legibilidad";
    homepage    = "https://fonts.google.com/specimen/Readex+Pro";
    license     = lib.licenses.ofl;
    platforms   = lib.platforms.all;
  };
}
