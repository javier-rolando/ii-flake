{
  description = "Mi configuración NixOS con ii-vynx (illogical-impulse) dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      # Commit pinned to match illogical-impulse-quickshell-git PKGBUILD
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?rev=7511545ee20664e3b8b8d3322c0ffe7567c56f7a";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dotfiles — por defecto usa el repo de ii-vynx.
    # Se puede sobreescribir desde otro flake apuntando a tu fork:
    #
    #   inputs.ii-flake.inputs.dotfiles.follows = "my-dots";
    #
    # donde "my-dots" sería tu propio input con url = "github:user/ii-vynx".
    dotfiles = {
      url = "git+https://github.com/javier-rolando/ii-vynx?ref=nixos&submodules=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, quickshell, nur, dotfiles, ... }:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};

      # Paquetes custom (oneui4-icons, material-symbols, etc.)
      customPkgs = import ./pkgs { inherit pkgs; };

      # Wrapper + deps Qt para QuickShell (igual que el PKGBUILD de Arch)
      qsPackage = import ./hm-modules/quickshell-wrapper.nix {
        inherit pkgs;
        qs = quickshell.packages.${system}.default;
      };

      # Entorno Python para QuickShell (replica el venv de Arch)
      pythonEnv = import ./hm-modules/python-env.nix { inherit pkgs; };

      # Argumentos extra que se pasan a todos los sub-módulos HM
      moduleArgs = { inherit inputs dotfiles customPkgs qsPackage pythonEnv; };
    in
    {
      # ── Paquetes exportados ──────────────────────────────────────────────────
      packages.${system} = customPkgs;

      # ── Módulo NixOS (nivel sistema) ─────────────────────────────────────────
      # Añade esto a tus nixosConfigurations:
      #   imports = [ inputs.ii-vynx.nixosModules.default ];
      #   ii-vynx.enable = true;
      nixosModules.default = (import ./nixos-module.nix) inputs;
      nixosModules.ii-vynx = self.nixosModules.default;

      # ── Módulo Home-Manager (nivel usuario) ──────────────────────────────────
      # Añade esto a tu home-manager:
      #   imports = [ inputs.ii-vynx.homeManagerModules.default ];
      #   programs.ii-vynx.enable = true;
      homeManagerModules.default = (import ./hm-module.nix) moduleArgs;
      homeManagerModules.ii-vynx = self.homeManagerModules.default;
    };
}
