{
  host,
  config,
  pkgs,
  lib,
  ...
}:

let
  borgHost = "backup.wlodek.lan";
  borgPort = "220";
  borgUser = "borg";
  borgKeyDir = "/etc/borg-backup";

  notifyAll = pkgs.writeShellScript "borg-notify-all" ''
    urgency="$1"
    timeout="$2"
    title="$3"
    body="$4"
    for ud in /run/user/[0-9]*; do
      [ -S "$ud/bus" ] || continue
      uid=$(${pkgs.coreutils}/bin/basename "$ud")
      user=$(${pkgs.coreutils}/bin/id -nu "$uid")
      ${pkgs.util-linux}/bin/runuser -u "$user" -- env \
        DBUS_SESSION_BUS_ADDRESS="unix:path=$ud/bus" \
        ${pkgs.libnotify}/bin/notify-send \
        -u "$urgency" -a BorgBackup -t "$timeout" "$title" "$body"
    done
    exit 0
  '';
in

{
  users.groups.borgbackup = { };

  services.borgbackup.jobs.home = {
    paths = [ "/home/krystian" ];

    exclude = [ "re:(^|/)\\." ];

    repo = "ssh://${borgUser}@${borgHost}:${borgPort}/srv/borg/${host}";

    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${borgKeyDir}/passphrase";
    };

    environment = {
      BORG_RSH =
        "ssh -i ${borgKeyDir}/id_ed25519 -o UserKnownHostsFile=${borgKeyDir}/known_hosts -o IdentitiesOnly=yes";
    };

    compression = "auto,zstd";

    startAt = "daily";
    persistentTimer = true;

    doInit = true;

    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };

  systemd.services =
    {
      "borg-notify-failure@" = {
        description = "Notify about failed backup (%i)";
        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            let
              notifyScript = pkgs.writeShellScript "borg-notify-failure" ''
                if ${pkgs.iputils}/bin/ping -c1 -W2 ${borgHost} >/dev/null 2>&1; then
                  ${notifyAll} critical 0 \
                    "Backup failed" \
                    "Unit: $1 — see journalctl -u $1"
                else
                  ${notifyAll} normal 0 \
                    "Backup skipped" \
                    "${borgHost} unreachable — will catch up automatically when back home"
                fi
              '';
            in
            "${notifyScript} %i";
        };
      };

      "borg-notify-success@" = {
        description = "Notify about successful backup (%i)";
        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            let
              notifyScript = pkgs.writeShellScript "borg-notify-success" ''
                ${notifyAll} normal 10000 \
                  "Backup completed" \
                  "$1 finished successfully"
              '';
            in
            "${notifyScript} %i";
        };
      };
    }
    // builtins.listToAttrs (
      builtins.map
        (name: {
          name = "borgbackup-job-${name}";
          value = {
            onFailure = [ "borg-notify-failure@%N.service" ];
            onSuccess = [ "borg-notify-success@%N.service" ];

            serviceConfig.TimeoutStartSec = "2h";

            preStart = lib.mkBefore ''
              echo "Waiting for network (${borgHost})..."
              tries=60
              until ${pkgs.iputils}/bin/ping -c1 -W2 ${borgHost} >/dev/null; do
                tries=$((tries - 1))
                if [ "$tries" -le 0 ]; then
                  echo "Network unreachable: ${borgHost}" >&2
                  exit 1
                fi
                sleep 5
              done
            '';
          };
        })
        (builtins.attrNames config.services.borgbackup.jobs)
    );

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "borgctl" ''
      export BORG_RSH="ssh -i ${borgKeyDir}/id_ed25519 -o UserKnownHostsFile=${borgKeyDir}/known_hosts -o IdentitiesOnly=yes"
      export BORG_PASSCOMMAND="cat ${borgKeyDir}/passphrase"
      exec ${pkgs.borgbackup}/bin/borg "$@"
    '')
  ];
}
