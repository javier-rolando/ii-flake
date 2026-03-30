{ pkgs }:

{
  # Iconos OneUI4 (fork personalizado de end-4)
  illogical-impulse-oneui4-icons = pkgs.callPackage ./oneui4-icons {};

  # Fuente Material Symbols (variable, Google)
  material-symbols = pkgs.callPackage ./material-symbols {};

  # Space Grotesk (otf-space-grotesk — no disponible como nixpkg estándar)
  space-grotesk = pkgs.callPackage ./space-grotesk {};

  # Readex Pro (ttf-readex-pro — no disponible como nixpkg estándar)
  readex-pro = pkgs.callPackage ./readex-pro {};

  # Google Sans Flex — fuente principal de ii-vynx (descargada por el install script en Arch)
  google-sans-flex = pkgs.callPackage ./google-sans-flex {};
}
