{ config, pkgs, ... }:

{
  home-manager.useUserPackages = true;

  # Intentionally false:
  # Home Manager needs its own nixpkgs instance so that
  # its nixpkgs configuration can contain allowUnfree.
  home-manager.useGlobalPkgs = false;

  home-manager.users.krystian = {
    imports = [
      ../home/krystian.nix
    ];

    nixpkgs.config.allowUnfree = true;
  };

  home-manager.users.root = {
    imports = [
      ../home/root.nix
    ];
  };
}
