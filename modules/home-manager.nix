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

  home-manager.users.guest = {
    imports = [
      ../home/guest.nix
    ];

    nixpkgs.config.allowUnfree = true;
  };
}