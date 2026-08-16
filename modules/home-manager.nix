{ config, pkgs, ... }:

{
  home-manager.useUserPackages = true;

  home-manager.useGlobalPkgs = false;

  home-manager.users.krystian = {
    imports = [
      ../home/krystian.nix
    ];

    nixpkgs.config.allowUnfree = true;
  };
}