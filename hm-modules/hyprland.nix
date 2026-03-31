# hm-modules/hyprland.nix
{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    # IMPORTANTE: Usamos el paquete del flake oficial para que coincida con los plugins
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];

    # Aquí podés pasar tu config de Hyprbars
    # settings = {
    #   "plugin:hyprbars" = {
    #     bar_height = 20;
    #     bar_color = "rgb(1a1a1a)";
    #     # botones, fuentes, etc.
    #   };
    # };
  };
}
