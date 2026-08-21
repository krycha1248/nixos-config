{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    #../../modules/urbackup-client.nix
  ];

  #services.urbackup-client = {
  #  enable = true;

    # Ports open only in the home WiFi, scoped to the server's IP.
  #  openFirewall = false;
  #  firewallWifiNetworks = [ "Dom_15_srv" ];
  #  serverIp = "192.168.1.24";
  #};

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
