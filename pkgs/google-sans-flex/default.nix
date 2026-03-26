# Google Sans Flex — fuente variable usada como fuente principal por ii-vynx/QuickShell
# Fuente original de Google, resubida a GitHub por end-4 para acceso sin restricciones
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "google-sans-flex";
  version = "unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "end-4";
    repo  = "google-sans-flex";
    rev   = "251aa5abd30496368f634e54ce2a508fe5a2fdfa";
    hash  = "sha256-XTMh9vp0BAziVLXVu73mCo5+xkejkZEZ27ZLAg6wDtA=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 *.ttf -t $out/share/fonts/TTF
    runHook postInstall
  '';

  meta = {
    description = "Google Sans Flex — fuente variable principal de ii-vynx/QuickShell";
    homepage    = "https://fonts.google.com/specimen/Google+Sans+Flex";
    license     = lib.licenses.ofl;
    platforms   = lib.platforms.all;
  };
}
