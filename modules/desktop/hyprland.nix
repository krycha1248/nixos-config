{
  pkgs,
  ...
}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  hyprlandSessions = "${pkgs.hyprland}/share/wayland-sessions";
in {

  programs.hyprland = {
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

    settings = {
      default_session = {
        command =
          "${tuigreet} --time --remember --remember-session --sessions ${hyprlandSessions}";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";

    StandardInput = "tty";
    StandardOutput = "journal";
    StandardError = "journal";

    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.systemPackages = with pkgs; [
    hypridle
    hyprlock
    hyprpaper
    wlogout
    wayland-utils
    wl-clipboard
    brightnessctl
  ];
}
