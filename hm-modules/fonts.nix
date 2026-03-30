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
      customPkgs.google-sans-flex # Google Sans Flex (fuente principal de QS — instalada por setup script en Arch)

      # Fuente Gabarito (NUR)
      nurPkgs.repos.skiletro.gabarito
    ];
  };
}
