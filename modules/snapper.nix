{
  services.snapper = {
    snapshotInterval = "hourly";
    persistentTimer = true;

    filters = builtins.concatStringsSep "\n" [
      "/tmp"
      "/var/log"
      "/var/lib/systemd/coredump"
      "/var/tmp"
      "/root/.cache"
    ];

    configs = {
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "krystian" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        NUMBER_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 5;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 3;
        TIMELINE_LIMIT_YEARLY = 0;
      };

      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "krystian" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        NUMBER_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 3;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
