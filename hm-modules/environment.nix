# hm-modules/environment.nix
# Variables de entorno y servicios systemd de sesión

{}:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.ii-vynx;
in
{
  config = lib.mkIf cfg.enable {

    home.sessionVariables = {
      # Python venv para QS (los scripts en quickshell/ii/scripts lo sourcean)
      ILLOGICAL_IMPULSE_VIRTUAL_ENV = "${config.home.homeDirectory}/.local/state/quickshell/.venv";

      # Ruta al config de QuickShell (QS lo usa como directorio base)
      qsConfig = "${config.home.homeDirectory}/.config/quickshell/ii";

      # Wayland / Qt
      NIXOS_OZONE_WL           = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM          = "wayland;xcb";
      QT_QPA_PLATFORMTHEME     = "kde";
      XDG_MENU_PREFIX          = "plasma-";

      # Terminal
      TERMINAL = "kitty -1";
    };

    # Propagar variables a los servicios systemd de usuario
    # (Hyprland, hypridle, easyeffects, etc. las necesitan)
    systemd.user.sessionVariables = config.home.sessionVariables;

    # qt6ct para configuración de tema Qt6 desde la GUI
    home.packages = [ pkgs.qt6Packages.qt6ct ];
  };
}
