{ pkgs, ... }:

let
  soundTheme = pkgs.sound-theme-freedesktop;

  usbEvent = pkgs.writeShellScript "udiskie-usb-event" ''
    case "$1" in
      device_mounted)
        ${pkgs.pipewire}/bin/pw-play \
          "${soundTheme}/share/sounds/freedesktop/stereo/device-added.oga"
        ;;

      device_removed)
        ${pkgs.pipewire}/bin/pw-play \
          "${soundTheme}/share/sounds/freedesktop/stereo/device-removed.oga"
        ;;
    esac
  '';

in
{
  home.packages = [
    pkgs.udiskie
    pkgs.sound-theme-freedesktop
  ];

  systemd.user.services.udiskie = {
    Unit = {
      Description = "Udiskie automounter";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart =
        "${pkgs.udiskie}/bin/udiskie --automount --event-hook '${usbEvent} \"{event}\" \"{device_presentation}\"'";

      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
