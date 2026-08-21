{
  pkgs,
  ...
}: let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";

  uwsmSessions = pkgs.runCommand "hyprland-uwsm-sessions" { } ''
    mkdir -p $out
    ln -s "${pkgs.hyprland}/share/wayland-sessions/hyprland-uwsm.desktop" $out/hyprland-uwsm.desktop
  '';
in {

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  security.pam.services.hyprlock = { };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command =
          "${tuigreet} --time --remember --remember-session --sessions ${uwsmSessions}";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    StandardInput = "tty";
    StandardOutput = "journal";
    StandardError = "journal";

    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
