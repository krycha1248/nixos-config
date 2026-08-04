{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/hyprland.nix
  ];


  # ------------------------------------------------------------
  # Hostname
  # ------------------------------------------------------------

  networking.hostName = "thinkpad";


  # ------------------------------------------------------------
  # Lanzaboote / Secure Boot
  # ------------------------------------------------------------

  boot.loader.systemd-boot.enable = false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.loader.systemd-boot.xbootldrMountPoint = "/boot";


  # ------------------------------------------------------------
  # LUKS
  # ------------------------------------------------------------

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/91957a49-7d61-40b5-80fe-caf8a2e35a13";


  # ------------------------------------------------------------
  # Intel
  # ------------------------------------------------------------

  hardware.cpu.intel.npu.enable = true;

  # ------------------------------------------------------------
  # Plymouth
  # ------------------------------------------------------------

  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=0"
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "udev.log_level=0"
    "rd.udev.log_level=0"
  ];
}
