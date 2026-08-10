{
  description = "Krystian's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/cd3b03e";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprdynamicmonitors.url =
      "github:fiffeek/hyprdynamicmonitors";
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

            # Stylix
            stylix.nixosModules.stylix

            # Home Manager
            home-manager.nixosModules.home-manager

            # Secure Boot
            lanzaboote.nixosModules.lanzaboote

            {
              _module.args.catppuccin = catppuccin;

              home-manager.extraSpecialArgs = {
                host = name;
                inherit hyprdynamicmonitors;
              };

              # Stylix for Home Manager
              home-manager.sharedModules = [
                stylix.homeModules.stylix
              ];
            }
          ];
        };
    in
    {
      nixosConfigurations =
        builtins.mapAttrs mkHost hostConfigs;
    };
}
