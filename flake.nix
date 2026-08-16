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

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      stylix,
      hyprdynamicmonitors,
      ...
    }:

    let
      system = "x86_64-linux";

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

            stylix.nixosModules.stylix

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

            lanzaboote.nixosModules.lanzaboote
          ];
        };

    in
    {
      nixosConfigurations.thinkpad = mkHost "thinkpad" ./hosts/thinkpad;
      nixosConfigurations.dell = mkHost "dell" ./hosts/dell;
    };
}