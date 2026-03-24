# Módulo NixOS (nivel sistema) para ii-vynx / illogical-impulse
# Añade a tu configuración NixOS:
#
#   imports = [ inputs.ii-vynx.nixosModules.default ];
#   ii-vynx.enable = true;
#   ii-vynx.user   = "tunombre";

{ config, lib, pkgs, ... }:

let
  cfg = config.ii-vynx;
in
{
  options.ii-vynx = {
    enable = lib.mkEnableOption "Configuración de sistema para ii-vynx (illogical-impulse)";

    user = lib.mkOption {
      type    = lib.types.str;
      example = "javier";
      description = "Usuario al que se aplica la configuración.";
    };
  };

  config = lib.mkIf cfg.enable {

    # ── Hyprland ──────────────────────────────────────────────────────────────
    programs.hyprland = {
      enable       = true;
      xwayland.enable = true;
    };

    # ── Audio: PipeWire (equivale a pipewire-pulse de Arch) ───────────────────
    services.pipewire = {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
      wireplumber.enable = true;
    };
    security.rtkit.enable = true;

    # ── Bluetooth ─────────────────────────────────────────────────────────────
    hardware.bluetooth = {
      enable      = true;
      powerOnBoot = true;
    };

    # ── NetworkManager ────────────────────────────────────────────────────────
    networking.networkmanager.enable = true;

    # ── Polkit ────────────────────────────────────────────────────────────────
    security.polkit.enable = true;

    # Agente polkit de KDE (se lanza como servicio de usuario via HM)
    systemd.user.services.polkit-kde-agent = {
      description = "KDE Polkit Authentication Agent";
      wantedBy    = [ "graphical-session.target" ];
      wants       = [ "graphical-session.target" ];
      after       = [ "graphical-session.target" ];
      serviceConfig = {
        Type      = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart   = "on-failure";
      };
    };

    # ── GNOME Keyring (secrets, para ssh-agent y libsecret) ───────────────────
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.greetd.enableGnomeKeyring  = lib.mkDefault true;

    # ── PAM para hyprlock (pantalla de bloqueo) ───────────────────────────────
    security.pam.services.hyprlock = {};

    # ── GeoClue2 (ubicación para hipersol / brillo segun hora) ────────────────
    services.geoclue2.enable = true;

    # ── XDG Portals ───────────────────────────────────────────────────────────
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
    };

    # ── ddcutil sin sudo (i2c) y brightnessctl sin sudo (video) ──────────────
    hardware.i2c.enable = lib.mkDefault true;
    users.users.${cfg.user}.extraGroups = [ "i2c" "video" ];

    # ── Tipografías del sistema ────────────────────────────────────────────────
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable        = true;
      fontconfig.enable     = true;
    };

    # ── Variables de entorno para toda la sesión ──────────────────────────────
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP   = "Hyprland";
      XDG_SESSION_TYPE      = "wayland";
      XDG_SESSION_DESKTOP   = "Hyprland";
      NIXOS_OZONE_WL        = "1";           # Electron en Wayland
    };
  };
}
