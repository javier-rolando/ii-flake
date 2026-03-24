# hm-modules/fonts.nix
# Tipografías de usuario

{ customPkgs, inputs }:

{ config, lib, pkgs, ... }:

let
  cfg    = config.programs.ii-vynx;
  nurPkgs = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  config = lib.mkIf cfg.enable {
    # Activar fontconfig del usuario para que Nix encuentre las fuentes
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # Material Symbols (ttf-material-symbols-variable-git)
      customPkgs.material-symbols

      # Nerd Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.caskaydia-cove

      # Google Fonts (usadas en QS y Hyprland)
      rubik                       # Rubik variable (ttf-rubik-vf)
      twemoji-color-font           # Twemoji (ttf-twemoji)
      customPkgs.space-grotesk    # Space Grotesk (otf-space-grotesk)
      customPkgs.readex-pro       # Readex Pro (ttf-readex-pro)

      # Fuente Gabarito (NUR)
      nurPkgs.repos.skiletro.gabarito
    ];

    # Wrapper fontconfig para incluir las fuentes del sistema NixOS
    xdg.configFile."fontconfig/fonts.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
          <!-- Fuentes NixOS sistema -->
          <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
          <!-- Anti-aliasing -->
          <match target="font">
              <edit name="rgba" mode="assign"><const>none</const></edit>
          </match>
      </fontconfig>
    '';
  };
}
