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
    ];

    shell = pkgs.zsh;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
