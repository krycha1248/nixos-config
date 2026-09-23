{ pkgs, ... }:

{
  users.users.krystian = {
    isNormalUser = true;

    description = "Krystian";

    extraGroups = [
      "wheel"
      "networkmanager"
      "vboxusers"
      "libvirtd"
      "kvm"
      "scanner"
      "lp"
      "netbird-wt0"
    ];

    shell = pkgs.zsh;
  };

  users.users.guest = {
    isNormalUser = true;

    description = "Guest";

    extraGroups = [];

    shell = pkgs.bash;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
