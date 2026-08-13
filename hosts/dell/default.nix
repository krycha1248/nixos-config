{ pkgs, config, ... }:

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

  boot.initrd.kernelModules = [
    "i915"
  ];

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


  # ------------------------------------------------------------
  # Graphics / Intel VA-API
  # ------------------------------------------------------------

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      libva
    ];
  };


  # ------------------------------------------------------------
  # NVIDIA / Intel hybrid graphics
  # ------------------------------------------------------------

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    # NVIDIA MX450 / Turing
    # Use proprietary NVIDIA driver rather than nouveau.
    open = false;

    # Required for PRIME / Wayland.
    modesetting.enable = true;

    # Enable nvidia-settings.
    nvidiaSettings = true;

    # Use NVIDIA driver matching the running kernel.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Allow the NVIDIA GPU to power down when unused.
    powerManagement.enable = true;

    # Intel = primary GPU
    # NVIDIA = PRIME offload GPU
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # ------------------------------------------------------------
  # Fingerprint reader
  # ------------------------------------------------------------

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-broadcom;
    };
  };


  # ------------------------------------------------------------
  # Fingerprint authentication
  # ------------------------------------------------------------

  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
    polkit-1.fprintAuth = true;
    greetd.fprintAuth = false;
    hyprlock.fprintAuth = true;
  };
}
