{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/power.nix
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/printing.nix
    ../../modules/desktop/thunar.nix
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
  boot.loader.systemd-boot.configurationLimit = 5;


  # ------------------------------------------------------------
  # LUKS
  # ------------------------------------------------------------

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/91957a49-7d61-40b5-80fe-caf8a2e35a13";


  # ------------------------------------------------------------
  # Docker & Virtualbox
  # ------------------------------------------------------------

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  systemd.services.docker = {
    wantedBy = lib.mkForce [];
  };


  # ------------------------------------------------------------
  # Lid actions
  # ------------------------------------------------------------

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "suspend";
  };

  # ------------------------------------------------------------
  # Plymouth
  # ------------------------------------------------------------

  boot.initrd.kernelModules = [ "i915" ];
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  boot.kernelParams = [
    "quiet"
    "splash"
    "systemd.show_status=false"
    "rd.systemd.show_status=false"
    "udev.log_level=0"
    "rd.udev.log_level=0"
  ];
}
