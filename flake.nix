{
  description = "Krystian's NixOS configurations";

  inputs = {
    # ----------------------------------------------------------
    # NixOS
    # ----------------------------------------------------------

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # ----------------------------------------------------------
    # Home Manager
    # ----------------------------------------------------------

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ----------------------------------------------------------
    # Lanzaboote
    # ----------------------------------------------------------

    lanzaboote = {
      url = "github:nix-community/lanzaboote/cd3b03e";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ----------------------------------------------------------
    # Theming
    # ----------------------------------------------------------

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ----------------------------------------------------------
    # Hyprland
    # ----------------------------------------------------------

    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      catppuccin,
      stylix,
      hyprdynamicmonitors,
      ...
    }:

    let
      system = "x86_64-linux";

      hostConfigs = {
        thinkpad = ./hosts/thinkpad;
        dell = ./hosts/dell;
      };

      mkHost =
        name: hostPath:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            host = name;
            inherit hyprdynamicmonitors;
          };

          modules = [
            hostPath
            ./modules/common.nix

            # --------------------------------------------------
            # Stylix
            # --------------------------------------------------

            stylix.nixosModules.stylix

            # --------------------------------------------------
            # Home Manager
            # --------------------------------------------------

            home-manager.nixosModules.home-manager

            {
              home-manager.extraSpecialArgs = {
                host = name;
                inherit hyprdynamicmonitors;
              };

              home-manager.sharedModules = [
                stylix.homeModules.stylix
              ];
            }

            # --------------------------------------------------
            # Lanzaboote
            # --------------------------------------------------

            lanzaboote.nixosModules.lanzaboote

            {
              _module.args.catppuccin = catppuccin;
            }
          ];
        };
    in
    {
      nixosConfigurations = builtins.mapAttrs mkHost hostConfigs;
    };
}
