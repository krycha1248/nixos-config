{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ------------------------------------------------------------
  # Hostname
  # ------------------------------------------------------------

  networking.hostName = "thinkpad";


  # ------------------------------------------------------------
  # LUKS
  # ------------------------------------------------------------

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/91957a49-7d61-40b5-80fe-caf8a2e35a13";
}
