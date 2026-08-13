{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/power.nix
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/printing.nix
    ../../modules/desktop/thunar.nix
    ../../modules/desktop/obs.nix
    ../../modules/desktop/virtualisation.nix
  ];


  # ------------------------------------------------------------
  # Hostname
  # ------------------------------------------------------------

  networking.hostName = "dell";


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
    "/dev/disk/by-uuid/49db567b-8214-493e-9441-1db4fd04b5d8";


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
