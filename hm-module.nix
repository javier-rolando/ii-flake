# Módulo Home-Manager principal para ii-vynx
# Importa todos los sub-módulos y expone la opción programs.ii-vynx.enable

{ inputs, dotfiles, customPkgs, qsPackage, pythonEnv, hyprland, hyprland-plugins }:

{ config, lib, pkgs, ... }:

{
  imports = [
    (import ./hm-modules/packages.nix     { inherit dotfiles customPkgs qsPackage pythonEnv; })
    (import ./hm-modules/fonts.nix        { inherit customPkgs inputs; })
    (import ./hm-modules/dotfiles.nix     { inherit dotfiles customPkgs pythonEnv; })
    (import ./hm-modules/environment.nix  {})
    (import ./hm-modules/hyprland.nix     { inherit inputs; })
  ];

  options.programs.ii-vynx = {
    enable = lib.mkEnableOption "Configuración ii-vynx (illogical-impulse) para Home-Manager";
  };
}
