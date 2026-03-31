# hm-modules/packages.nix
# Todos los paquetes de usuario equivalentes a los PKGBUILDs de dist-arch

{ dotfiles, customPkgs, qsPackage, pythonEnv, inputs }:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.ii-vynx;
  hyprPkg = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [

      # ── illogical-impulse-audio ─────────────────────────────────────────────
      cava                        # visualizador audio (usado en Quickshell)
      lxqt.pavucontrol-qt         # control de volumen Qt (usado en Hyprland+QS)
      wireplumber                 # sesión WirePlumber
      pipewire                    # pipewire-pulse: pactl viene de aquí en NixOS
      pulseaudio                  # pactl + parec (usados en scripts de QS/audio)
      libdbusmenu-gtk3            # menús DBus GTK3
      playerctl                   # control reproductores MPRIS

      # ── illogical-impulse-backlight ─────────────────────────────────────────
      (geoclue2.override { withDemoAgent = true; })  # demonio de ubicación
      brightnessctl               # control brillo (teclado/monitor integrado)
      ddcutil                     # control brillo monitores externos via DDC

      # ── illogical-impulse-basic ─────────────────────────────────────────────
      bc                          # calculadora CLI (scripts de colores)
      coreutils                   # utilidades básicas
      cliphist                    # historial portapapeles Wayland
      curl                        # descargas HTTP
      wget                        # descargas HTTP
      ripgrep                     # búsqueda de texto rápida
      jq                          # procesador JSON (ampliamente usado)
      xdg-user-dirs               # directorios XDG estándar
      rsync                       # sincronización de archivos
      yq-go                       # yq: procesar YAML/JSON/TOML desde CLI

      # ── illogical-impulse-bibata-modern-classic-bin ─────────────────────────
      bibata-cursors              # cursor tema Bibata-Modern-Classic

      # ── illogical-impulse-fonts-themes ──────────────────────────────────────
      adw-gtk3                    # tema GTK3 Adwaita mejorado
      kdePackages.breeze          # tema KDE Breeze (usado en kdeglobals)
      kdePackages.breeze-icons    # iconos Breeze
      # breeze-plus: no en nixpkgs (TODO: buscar alternativa o compilar)
      darkly                      # tema Qt/KDE oscuro (darkly-bin en Arch)
      eza                         # ls moderno con iconos (alias en fish)
      fish                        # shell principal
      fontconfig                  # configuración tipografías
      kitty                       # terminal (en fuzzel, Hyprland, kdeglobals, QS)
      matugen                     # generación paleta Material You
      starship                    # prompt para fish
      nerd-fonts.jetbrains-mono   # JetBrainsMono Nerd Font
      rubik                       # fuente Rubik variable
      twemoji-color-font          # emojis Twemoji (fallback emoji)
      # otf-space-grotesk → customPkgs.space-grotesk (ver pkgs/)
      customPkgs.space-grotesk
      # ttf-readex-pro → customPkgs.readex-pro (ver pkgs/)
      customPkgs.readex-pro
      # ttf-material-symbols-variable-git → customPkgs.material-symbols
      customPkgs.material-symbols
      # google-sans-flex → fuente principal de QS (instalada por setup script en Arch)
      customPkgs.google-sans-flex

      # ── illogical-impulse-hyprland ──────────────────────────────────────────
      # hyprland instalado a nivel sistema via nixos-module.nix
      hyprsunset                  # filtro color Wayland (f.lux/redshift)
      wl-clipboard                # portapapeles Wayland (wl-copy/wl-paste)

      # ── illogical-impulse-kde ───────────────────────────────────────────────
      kdePackages.bluedevil       # Bluetooth KDE (kcmshell6 kcm_bluetooth)
      gnome-keyring               # proveedor libsecret y secrets DBus
      networkmanager              # gestión de red (usado junto con plasma-nm)
      kdePackages.plasma-nm       # applet red KDE (kcmshell6 kcm_networkmanagement)
      kdePackages.polkit-kde-agent-1  # agente de autenticación polkit
      kdePackages.dolphin         # gestor de archivos (en Hyprland + QS config)
      kdePackages.systemsettings  # ajustes KDE (keybinds.conf)
      kdePackages.knewstuff        # módulo QML org.kde.newstuff (requerido por kcm_icons)
      kdePackages.ksvg             # módulo QML org.kde.ksvg (requerido por kcm_desktoptheme)
      kdePackages.libplasma        # módulo QML org.kde.kquickcontrolsaddons (absorbido en KDE6)
      kdePackages.kdeclarative     # org.kde.kquickcontrolsaddons (proveedor real en nixpkgs)

      # ── illogical-impulse-microtex-git ──────────────────────────────────────
      # MicroTeX: no disponible en nixpkgs (TODO: añadir derivación custom)

      # ── illogical-impulse-oneui4-icons-git ─────────────────────────────────
      customPkgs.illogical-impulse-oneui4-icons

      # ── illogical-impulse-portal ────────────────────────────────────────────
      # Los portales XDG se configuran a nivel sistema en nixos-module.nix
      # (xdg-desktop-portal-hyprland, kde, gtk ya están ahí)

      # ── illogical-impulse-python ────────────────────────────────────────────
      uv                          # gestor venvs Python (usado en install script)
      gtk4                        # biblioteca GTK4
      libadwaita                  # widgets Adwaita modernos
      libsoup_3                   # HTTP/WebSockets GLib
      libportal-gtk4              # portales XDG desde GTK4
      gobject-introspection       # introspección GObject (bindings Python)

      # ── illogical-impulse-quickshell-git ────────────────────────────────────
      jemalloc                    # allocator de memoria (dep runtime de QuickShell)
      qsPackage                   # QuickShell con deps Qt completas

      # ── illogical-impulse-screencapture ─────────────────────────────────────
      hyprshot                    # captura pantalla Hyprland (fallback en keybinds)
      slurp                       # selección área pantalla
      swappy                      # editor capturas de pantalla
      (tesseract5.override { enableLanguages = [ "eng" ]; })  # OCR + datos inglés
      wf-recorder                 # grabación pantalla Wayland

      # ── illogical-impulse-toolkit ───────────────────────────────────────────
      upower                      # información batería (QS)
      wtype                       # inyección teclado Wayland (fuzzel-emoji.sh)
      ydotool                     # automatización input Wayland (QS)

      # ── illogical-impulse-widgets ───────────────────────────────────────────
      fuzzel                      # launcher app (Hyprland + QS)
      glib                        # gsettings y utilidades GLib
      imagemagick                 # procesamiento imágenes (QS, magick)
      hypridle                    # daemon inactividad (pantalla de bloqueo)
      hyprlock                    # pantalla de bloqueo
      hyprPkg.hyprpicker          # recoge color de pantalla (usar del flake)
      songrec                     # reconocimiento de música (QS)
      translate-shell             # traducción desde terminal (QS)
      wlogout                     # menú cerrar sesión
      libqalculate                # qalc: calculadora en searchbar QS

      # ── Extras necesarios (no en dist-arch pero usados en los configs) ───────
      foot                        # terminal (QS + Hyprland config)
      mpv                         # reproductor multimedia
      mpvpaper                    # wallpapers de vídeo via mpv
      ffmpeg                      # conversión multimedia
      easyeffects                 # efectos de audio (en execs.conf)
      libnotify                   # notify-send (notificaciones)

      # Iconos de fallback para que Qt y GTK encuentren todos los iconos
      papirus-icon-theme
      adwaita-icon-theme
      hicolor-icon-theme
      gnome-icon-theme             # cobertura adicional iconos GNOME

      # gsettings (necesario para scripts de temas)
      # glib ya instalado más arriba provee el binario gsettings

      # Wallpaper y screenshots adicionales
      grim                        # captura pantalla Wayland (usado en keybinds + scripts OCR)

      # Qt6ct para configuración tema Qt6
      qt6Packages.qt6ct

      # Soporte Qt6 adicional (KDE)
      kdePackages.kdialog
      kdePackages.kirigami
      kdePackages.kde-cli-tools
      kdePackages.plasma-workspace  # plasma-apply-colorscheme

      # libsecret (para QuickShell key store)
      libsecret

      # Entorno Python (reemplaza el venv de Arch)
      pythonEnv

    ];
  };
}
