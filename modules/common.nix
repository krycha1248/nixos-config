{ config, pkgs, lib, ... }:

{
  # ------------------------------------------------------------
  # Desktop modules
  # ------------------------------------------------------------

  imports = [
    ./desktop/hyprland.nix
    ./desktop/power.nix
    ./desktop/bluetooth.nix
    ./desktop/printing.nix
    ./desktop/thunar.nix
    ./desktop/obs.nix
    ./desktop/virtualisation.nix
    ./system-packages.nix
  ];

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
  # Nix
  # ------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ------------------------------------------------------------
  # Networking
  # ------------------------------------------------------------

  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  networking.firewall.enable = true;

  security.pki.certificateFiles = [
    ../certs/wlodek-lan-root-ca.crt
  ];

  # ------------------------------------------------------------
  # Compatibility for dynamically linked binaries
  # ------------------------------------------------------------

  programs.nix-ld.enable = true;

  # ------------------------------------------------------------
  # Locale / keyboard / timezone
  # ------------------------------------------------------------

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_GB.UTF-8";

  console.keyMap = "pl";

  # ------------------------------------------------------------
  # Console
  # ------------------------------------------------------------

  console = {
    font = "ter-v24n";

    packages = with pkgs; [
      terminus_font
    ];
  };

  # ------------------------------------------------------------
  # SSH
  # ------------------------------------------------------------

  services.openssh = {
    enable = false;
  };

  # ------------------------------------------------------------
  # Shell
  # ------------------------------------------------------------

  programs.zsh.enable = true;

  # ------------------------------------------------------------
  # User
  # ------------------------------------------------------------

  users.users.krystian = {
    isNormalUser = true;

    description = "Krystian";

    extraGroups = [
      "wheel"
      "networkmanager"
      "vboxusers"
      "libvirtd"
    ];

    shell = pkgs.zsh;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

  # ------------------------------------------------------------
  # Home Manager
  # ------------------------------------------------------------

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

  # ------------------------------------------------------------
  # Others
  # ------------------------------------------------------------

  documentation.man.cache.enable = true;

  services.udisks2.enable = true;

  # ------------------------------------------------------------
  # Keychron
  # ------------------------------------------------------------

  services.udev.extraRules = ''
    # Keychron Link-KM (3434:d026) — Keychron Launcher / WebHID
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d026", MODE="0660", GROUP="users", TAG+="uaccess"
  '';

    # ------------------------------------------------------------
    # NixOS state version
    # ------------------------------------------------------------

  system.stateVersion = "26.05";
}
