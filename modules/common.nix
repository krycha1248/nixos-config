{ pkgs, ... }:

{
  # ------------------------------------------------------------
  # Desktop modules
  # ------------------------------------------------------------

  imports = [
    ./desktop/hyprland.nix
    ./desktop/graphics.nix
    ./desktop/gaming.nix
    ./desktop/hardware.nix
    ./desktop/power.nix
    ./desktop/bluetooth.nix
    ./desktop/printing.nix
    ./desktop/thunar.nix
    ./desktop/obs.nix
    ./desktop/virtualisation.nix
    ./desktop/android.nix
    ./system-packages.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
    ./home-manager.nix
    ./nix-settings.nix
  ];

  # ------------------------------------------------------------
  # Locale / keyboard / timezone
  # ------------------------------------------------------------

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_GB.UTF-8";

  console.keyMap = "pl";

  console = {
    font = "ter-v24n";

    packages = with pkgs; [
      terminus_font
    ];
  };

  # ------------------------------------------------------------
  # Others
  # ------------------------------------------------------------

  documentation.man.cache.enable = true;

  services.udisks2.enable = true;

  services.udev.extraRules = ''
    # Keychron Link-KM (3434:d026) — Keychron Launcher / WebHID
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d026", MODE="0660", GROUP="users", TAG+="uaccess"
  '';

  system.stateVersion = "26.05";
}