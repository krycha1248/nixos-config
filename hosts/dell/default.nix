{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    #../../modules/urbackup-client.nix
  ];

  #services.urbackup-client.enable = true;

  # ------------------------------------------------------------
  # Hostname
  # ------------------------------------------------------------

  networking.hostName = "dell";

  # ------------------------------------------------------------
  # LUKS
  # ------------------------------------------------------------

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/49db567b-8214-493e-9441-1db4fd04b5d8";

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
    powerManagement.finegrained = true;

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
