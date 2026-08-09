{ config, pkgs, lib, catppuccin, ... }:

{
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
  #networking.firewall.allowedTCPPorts = [
    #22
  #];


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

    #settings = {
    #  PermitRootLogin = "no";
    #  PasswordAuthentication = true;
    #};
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
    ];

    shell = pkgs.zsh;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };


  # ------------------------------------------------------------
  # Home Manager
  # ------------------------------------------------------------

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.krystian = {
    imports = [
      ../home/krystian.nix
      catppuccin.homeModules.catppuccin
    ];
  };

  home-manager.users.root = {
    imports = [
      ../home/root.nix
    ];
  };

  # ------------------------------------------------------------
  # System packages
  # ------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    sbctl
    cifs-utils
  ];


  # ------------------------------------------------------------
  # Others
  # ------------------------------------------------------------

  documentation.man.cache.enable = true;
  services.udisks2.enable = true;


  # ------------------------------------------------------------
  # NixOS state version
  # ------------------------------------------------------------

  system.stateVersion = "26.05";
}
