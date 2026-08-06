{ pkgs, ... }:

let
  soundTheme = pkgs.sound-theme-freedesktop;

  networkNotify = pkgs.writeShellScript "network-notify" ''
    lastState=""

    while true; do
      state="$(
        ${pkgs.networkmanager}/bin/nmcli -t -f GENERAL.STATE,GENERAL.CONNECTION device show 2>/dev/null |
          grep '^GENERAL.STATE:' |
          head -n1
      )"

      connection="$(
        ${pkgs.networkmanager}/bin/nmcli -t -f NAME,TYPE connection show --active 2>/dev/null |
          head -n1
      )"

      if [ "$state" != "$lastState" ]; then
        lastState="$state"

        if echo "$state" | grep -q '^GENERAL.STATE:100'; then
          name="$(echo "$connection" | cut -d: -f1)"
          type="$(echo "$connection" | cut -d: -f2)"

          ${pkgs.libnotify}/bin/notify-send \
            -a "Network" \
            "Network connected" \
            "$name ($type)"

          ${pkgs.pipewire}/bin/pw-play \
            "${soundTheme}/share/sounds/freedesktop/stereo/service-login.oga"

        elif echo "$state" | grep -q '^GENERAL.STATE:30'; then
          ${pkgs.libnotify}/bin/notify-send \
            -a "Network" \
            "Network disconnected" \
            "No active network connection"

          ${pkgs.pipewire}/bin/pw-play \
            "${soundTheme}/share/sounds/freedesktop/stereo/service-logout.oga"
        fi
      fi

      sleep 2
    done
  '';

in
{
  systemd.user.services.network-notify = {
    Unit = {
      Description = "Network connection notifications";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = networkNotify;
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
