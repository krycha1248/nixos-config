{
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.regreet = {
    enable = true;
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  services.greetd = {
    enable = true;
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";

    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";

    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    wayland-utils
    wl-clipboard
    brightnessctl
  ];
}
