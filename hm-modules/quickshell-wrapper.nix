# hm-modules/quickshell-wrapper.nix
# Wrapper de QuickShell con todos los deps Qt que necesita ii (igual al PKGBUILD de Arch)

{ pkgs, qs }:

let
  qtImports = with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtsvg
    qtwayland
    qt5compat
    qtimageformats
    qtmultimedia
    qtpositioning
    qtsensors
    qtquicktimeline
    qttools
    qttranslations
    qtvirtualkeyboard
    qtwebsockets
    syntax-highlighting
    kirigami
  ];
in

pkgs.stdenv.mkDerivation {
  name = "ii-vynx-quickshell-wrapper";

  dontUnpack    = true;
  dontConfigure = true;
  dontBuild     = true;

  nativeBuildInputs = [
    pkgs.makeWrapper
    pkgs.qt6.wrapQtAppsHook
  ];

  buildInputs = qtImports ++ [
    qs
    pkgs.gsettings-desktop-schemas
    pkgs.qt6.qtbase
    pkgs.qt6.qtdeclarative
    pkgs.qt6.qt5compat
    pkgs.qt6.qtimageformats
    pkgs.qt6.qtmultimedia
    pkgs.qt6.qtpositioning
    pkgs.qt6.qtquicktimeline
    pkgs.qt6.qtsensors
    pkgs.qt6.qtsvg
    pkgs.qt6.qttools
    pkgs.qt6.qttranslations
    pkgs.qt6.qtvirtualkeyboard
    pkgs.qt6.qtwayland
    pkgs.kdePackages.kdialog
    pkgs.kdePackages.syntax-highlighting
    pkgs.kdePackages.kirigami
  ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${qs}/bin/qs $out/bin/qs \
      --prefix XDG_DATA_DIRS : \
        ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}
    chmod +x $out/bin/qs
  '';

  meta.description = "QuickShell con deps Qt para ii-vynx";
}
