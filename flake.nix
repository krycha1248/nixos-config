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
      hyprdynamicmonitors,
      ...
    }:

    let
      /*
        hostConfigs is the single source of truth for hosts.

        The attribute name becomes the host identifier:

          thinkpad = ./hosts/thinkpad;

        means:

          host = "thinkpad"
      */
      hostConfigs = {
        thinkpad = ./hosts/thinkpad;

        # Add future hosts here:
        #
        # desktop = ./hosts/desktop;
        # server = ./hosts/server;
        # laptop = ./hosts/laptop;
      };

      /*
        Create a NixOS system from one host definition.

        `name` comes directly from the attribute name in hostConfigs.
      */
      mkHost =
        name: hostPath:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          /*
            Arguments available to NixOS modules.

            Any module can now do:

              { host, ... }:

            and receive:

              host = "thinkpad";
          */
          specialArgs = {
            host = name;
            inherit hyprdynamicmonitors;
          };

          modules = [
            hostPath
            ./modules/common.nix

            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote

            {
              _module.args.catppuccin = catppuccin;

              /*
                Arguments available to Home Manager modules.

                Any Home Manager module can now do:

                  { host, ... }:

                and receive the same host identifier.
              */
              home-manager.extraSpecialArgs = {
                host = name;
                inherit hyprdynamicmonitors;
              };
            }
          ];
        };

    in
    {
      /*
        Automatically turn:

          {
            thinkpad = ./hosts/thinkpad;
          }

        into:

          {
            thinkpad = mkHost "thinkpad" ./hosts/thinkpad;
          }
      */
      nixosConfigurations =
        builtins.mapAttrs mkHost hostConfigs;
    };
}
