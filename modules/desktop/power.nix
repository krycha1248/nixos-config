{ pkgs, ... }:

{
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}="power-profile-ac.service"
    SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", TAG+="systemd", ENV{SYSTEMD_WANTS}="power-profile-battery.service"
  '';

  systemd.services.power-profile-ac = {
    description = "Set balanced power profile on AC";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced";
    };
  };

  systemd.services.power-profile-battery = {
    description = "Set power saver profile on battery";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver";
    };
  };
}