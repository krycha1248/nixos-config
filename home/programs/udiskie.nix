{ pkgs, ... }:

{
  home.packages = [
    pkgs.udiskie
  ];

  systemd.user.services.udiskie = {
    Unit = {
      Description = "Automount removable drives";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.udiskie}/bin/udiskie --notify";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
