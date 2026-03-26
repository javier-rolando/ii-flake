# hm-modules/dotfiles.nix
# Gestión de dotfiles de ii-vynx via Home-Manager
# Usa los archivos locales de ./ii-vynx/dots en lugar de pulling desde GitHub

{ dotfiles, customPkgs, pythonEnv }:

{ config, lib, pkgs, ... }:

let
  cfg  = config.programs.ii-vynx;
  dots = "${dotfiles}/dots";

  # Directorio de quickshell parcheado para NixOS:
  # - Reemplaza shebangs complejos de venv por #!/usr/bin/env python3
  # - Suprime errores de permiso al escribir en /dev/pts
  quickshellPatched = pkgs.runCommand "quickshell-ii-patched" {
    buildInputs = [ pkgs.bash pythonEnv ];
  } ''
    cp -r ${dots}/.config/quickshell $out
    chmod -R +w $out

    # Reemplazar shebangs complejos que sourcean el venv con python3 directo
    find $out -name "*.py" -print0 | \
      xargs -0 sed -i 's|^#!.*ILLOGICAL_IMPULSE_VIRT.*|#!/usr/bin/env python3|'

    # Suprimir errores de permisos en /dev/pts al aplicar colores
    sed -i 's|/dev/pts/\*|/dev/pts/* 2>/dev/null|g' \
      $out/ii/scripts/colors/applycolor.sh || true

    patchShebangs $out
  '';

in
{
  config = lib.mkIf cfg.enable {

    # ── Venv falso para QuickShell ────────────────────────────────────────────
    # Los scripts de QS sourcean $ILLOGICAL_IMPULSE_VIRTUAL_ENV/bin/activate
    # En NixOS lo apuntamos directamente al pythonEnv de Nix
    home.file = {
      ".local/state/quickshell/.venv/bin/activate".text = ''
        # Generado por ii-vynx flake — no editar manualmente
        export VIRTUAL_ENV="${pythonEnv}"
        export PATH="${pythonEnv}/bin:$PATH"
        deactivate() { return 0; }
      '';
      ".local/state/quickshell/.venv/bin/python".source =
        "${pythonEnv}/bin/python3";
      ".local/state/quickshell/.venv/bin/python3".source =
        "${pythonEnv}/bin/python3";
      ".local/state/quickshell/.venv/pyvenv.cfg".text = ''
        home = ${pythonEnv}/bin
        include-system-site-packages = false
        version = 3.12.0
      '';

      # Icono de app
      ".local/share/icons/hicolor/scalable/apps/illogical-impulse.svg".source =
        "${dots}/.local/share/icons/illogical-impulse.svg";
    };

    # ── Shell: fish ──────────────────────────────────────────────────────────
    programs.starship.settings = builtins.fromTOML
      (builtins.readFile "${dots}/.config/starship.toml");

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        # Cargar config de ii-vynx
        if test -f $HOME/.config/fish/config-ii.fish
          source $HOME/.config/fish/config-ii.fish
        end
      '';
    };
    programs.starship.enable = true;

    # ── GTK / iconos ─────────────────────────────────────────────────────────
    gtk = {
      enable = lib.mkDefault true;
      iconTheme = {
        name    = lib.mkDefault "OneUI-dark";
        package = lib.mkDefault customPkgs.illogical-impulse-oneui4-icons;
      };
    };
    dconf.settings."org/gnome/desktop/interface".icon-theme =
      lib.mkDefault "OneUI-dark";

    # Symlink de Adwaita para que QS lo encuentre en XDG_DATA_DIRS
    home.file.".local/share/icons/Adwaita".source =
      "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";

    # ── XDG Config Files ─────────────────────────────────────────────────────
    xdg.configFile = {

      # ── Flags de aplicaciones ────────────────────────────────────────────
      "chrome-flags.conf".source  = "${dots}/.config/chrome-flags.conf";
      "code-flags.conf".source    = "${dots}/.config/code-flags.conf";
      "thorium-flags.conf".source = "${dots}/.config/thorium-flags.conf";

      # ── Temas ────────────────────────────────────────────────────────────
      "darklyrc".source   = "${dots}/.config/darklyrc";
      "Kvantum".source    = "${dots}/.config/Kvantum";

      # ── KDE apps ─────────────────────────────────────────────────────────
      # dolphinrc: manejado como copia mutable en el activation script
      #            (Dolphin necesita escribir en él para guardar estado)
      "kde-material-you-colors".source = "${dots}/.config/kde-material-you-colors";
      "konsolerc".source           = "${dots}/.config/konsolerc";

      # ── Terminales ───────────────────────────────────────────────────────
      "foot".source  = "${dots}/.config/foot";
      "kitty".source = "${dots}/.config/kitty";

      # ── Launcher ─────────────────────────────────────────────────────────
      "fuzzel".source = "${dots}/.config/fuzzel";

      # ── Multimedia ───────────────────────────────────────────────────────
      "mpv".source = "${dots}/.config/mpv";

      # ── Matugen (paleta Material You) ─────────────────────────────────────
      "matugen".source = "${dots}/.config/matugen";

      # ── Wlogout ───────────────────────────────────────────────────────────
      "wlogout".source = "${dots}/.config/wlogout";

      # ── XDG Desktop Portal ────────────────────────────────────────────────
      "xdg-desktop-portal".source = "${dots}/.config/xdg-desktop-portal";

      # ── ZSH helpers ──────────────────────────────────────────────────────
      "zshrc.d".source = "${dots}/.config/zshrc.d";

      # Fontconfig: incluir /etc/fonts/fonts.conf para fuentes del sistema
      "fontconfig/fonts.conf".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
        </fontconfig>
      '';

      # ── Fish config (cargado desde programs.fish.interactiveShellInit) ───
      "fish/config-ii.fish".source  = "${dots}/.config/fish/config.fish";
      "fish/auto-Hypr.fish".source  = "${dots}/.config/fish/auto-Hypr.fish";
      "fish/fish_variables".source  = "${dots}/.config/fish/fish_variables";

      # ── Hyprland ─────────────────────────────────────────────────────────
      # hyprland.conf original — usa $qsConfig = "ii" (QS lo resuelve via XDG)
      "hypr/hyprland.conf".source = "${dots}/.config/hypr/hyprland.conf";

      # env.conf: reescrito completamente para garantizar rutas NixOS
      # (no se incluye el original porque sobreescribiría XDG_DATA_DIRS)
      "hypr/hyprland/env.conf".text =
        let
          # Paquetes KDE que proveen módulos QML — store paths explícitos para
          # garantizar que systemsettings, kcm_icons, etc. los encuentren
          qmlPkgs = with pkgs.kdePackages; [
            libplasma          # org.kde.kquickcontrolsaddons (absorbido en KDE6)
            ksvg               # org.kde.ksvg
            knewstuff          # org.kde.newstuff
            kirigami           # org.kde.kirigami
            qqc2-desktop-style # org.kde.desktop
            qtdeclarative      # QtQuick, QtQml base
            qtquicktimeline
            qt5compat
            plasma-workspace   # módulos QML adicionales de Plasma
            kdeclarative       # org.kde.kquickcontrolsaddons (proveedor real)
          ];
          qmlPath = lib.makeSearchPath "lib/qt-6/qml" qmlPkgs;
        in
        ''
        # ── Rutas NixOS ──────────────────────────────────────────────────────
        env = PATH,${config.home.homeDirectory}/.nix-profile/bin:/etc/profiles/per-user/${config.home.username}/bin:$PATH
        env = XDG_DATA_DIRS,${config.home.homeDirectory}/.nix-profile/share:${config.home.homeDirectory}/.local/share:/etc/profiles/per-user/${config.home.username}/share:/run/current-system/sw/share:${config.home.homeDirectory}/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share
        env = QT_PLUGIN_PATH,${config.home.homeDirectory}/.nix-profile/lib/qt-6/plugins:${config.home.homeDirectory}/.nix-profile/lib/plugins:/run/current-system/sw/lib/qt-6/plugins
        env = QML2_IMPORT_PATH,${qmlPath}:${config.home.homeDirectory}/.nix-profile/lib/qt-6/qml:/etc/profiles/per-user/${config.home.username}/lib/qt-6/qml:/run/current-system/sw/lib/qt-6/qml
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

        # ── Contenido original de env.conf ───────────────────────────────────
        env = ELECTRON_OZONE_PLATFORM_HINT,auto
        env = QT_QPA_PLATFORM,wayland;xcb
        env = QT_QPA_PLATFORMTHEME,kde
        env = XDG_MENU_PREFIX,plasma-
        env = ILLOGICAL_IMPULSE_VIRTUAL_ENV,${config.home.homeDirectory}/.local/state/quickshell/.venv
        env = qsConfig,ii
        env = TERMINAL,kitty -1
      '';

      "hypr/hyprland/colors.conf".source   = "${dots}/.config/hypr/hyprland/colors.conf";
      "hypr/hyprland/execs.conf".source    = "${dots}/.config/hypr/hyprland/execs.conf";
      "hypr/hyprland/general.conf".source  = "${dots}/.config/hypr/hyprland/general.conf";
      "hypr/hyprland/keybinds.conf".source = "${dots}/.config/hypr/hyprland/keybinds.conf";
      "hypr/hyprland/rules.conf".source    = "${dots}/.config/hypr/hyprland/rules.conf";
      "hypr/hyprland/scripts".source       = "${dots}/.config/hypr/hyprland/scripts";

      "hypr/custom/env.conf".source        = "${dots}/.config/hypr/custom/env.conf";
      "hypr/custom/execs.conf".source      = "${dots}/.config/hypr/custom/execs.conf";
      "hypr/custom/general.conf".source    = "${dots}/.config/hypr/custom/general.conf";
      "hypr/custom/keybinds.conf".source   = "${dots}/.config/hypr/custom/keybinds.conf";
      "hypr/custom/rules.conf".source            = "${dots}/.config/hypr/custom/rules.conf";
      "hypr/custom/scripts".source               = "${dots}/.config/hypr/custom/scripts";
      "hypr/custom/special-workspaces.conf".source = "${dots}/.config/hypr/custom/special-workspaces.conf";

      "hypr/hyprlock".source    = "${dots}/.config/hypr/hyprlock";
      "hypr/hyprlock.conf".source = "${dots}/.config/hypr/hyprlock.conf";
      "hypr/hypridle.conf".source = "${dots}/.config/hypr/hypridle.conf";
      "hypr/monitors.conf".source = "${dots}/.config/hypr/monitors.conf";
      "hypr/workspaces.conf".source = "${dots}/.config/hypr/workspaces.conf";

      # ── QuickShell (parcheado para NixOS) ─────────────────────────────────
      "quickshell".source = quickshellPatched;

    };

    # ── Archivos con estado (se copian una vez, son mutables) ────────────────
    home.activation.copyIiVynxStatefulConfigs =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        configPath="${dots}/.config"
        targetPath="$HOME/.config"

        # illogical-impulse/config.json — solo si no existe
        $DRY_RUN_CMD mkdir -p "$targetPath/illogical-impulse"
        if [ ! -f "$targetPath/illogical-impulse/config.json" ]; then
          if [ -f "$configPath/illogical-impulse/config.json" ]; then
            $DRY_RUN_CMD cp "$configPath/illogical-impulse/config.json" \
              "$targetPath/illogical-impulse/config.json"
            $DRY_RUN_CMD chmod u+w "$targetPath/illogical-impulse/config.json"
          fi
        fi

        # kdeglobals — debe ser mutable para que plasma-apply-colorscheme lo cambie
        if [ -L "$targetPath/kdeglobals" ]; then
          $DRY_RUN_CMD rm "$targetPath/kdeglobals"
        fi
        if [ ! -f "$targetPath/kdeglobals" ]; then
          if [ -f "$configPath/kdeglobals" ]; then
            $DRY_RUN_CMD cp "$configPath/kdeglobals" "$targetPath/kdeglobals"
            $DRY_RUN_CMD chmod u+w "$targetPath/kdeglobals"
          fi
        else
          $DRY_RUN_CMD chmod u+w "$targetPath/kdeglobals"
        fi
        # dolphinrc — mutable para que Dolphin guarde estado de ventana
        if [ -L "$targetPath/dolphinrc" ]; then
          $DRY_RUN_CMD rm "$targetPath/dolphinrc"
        fi
        if [ ! -f "$targetPath/dolphinrc" ]; then
          if [ -f "$configPath/dolphinrc" ]; then
            $DRY_RUN_CMD cp "$configPath/dolphinrc" "$targetPath/dolphinrc"
            $DRY_RUN_CMD chmod u+w "$targetPath/dolphinrc"
          fi
        else
          $DRY_RUN_CMD chmod u+w "$targetPath/dolphinrc"
        fi
        # Konsole profiles — directorio mutable
        konsoleTarget="$HOME/.local/share/konsole"
        konsoleSource="${dots}/.local/share/konsole"
        if [ -L "$konsoleTarget" ]; then $DRY_RUN_CMD rm "$konsoleTarget"; fi
        $DRY_RUN_CMD mkdir -p "$konsoleTarget"
        for file in "$konsoleSource"/*; do
          filename="$(basename "$file")"
          if [ -e "$konsoleTarget/$filename" ]; then
            $DRY_RUN_CMD rm -f "$konsoleTarget/$filename"
          fi
          $DRY_RUN_CMD cp "$file" "$konsoleTarget/$filename"
          $DRY_RUN_CMD chmod u+w "$konsoleTarget/$filename"
        done

        # Corrección tema iconos en qt5ct / qt6ct
        for qt_conf in "$targetPath/qt5ct/qt5ct.conf" "$targetPath/qt6ct/qt6ct.conf"; do
          if [ -f "$qt_conf" ]; then
            $DRY_RUN_CMD sed -i 's/^icon_theme=OneUI$/icon_theme=OneUI-dark/' "$qt_conf"
          fi
        done
      '';
  };
}
