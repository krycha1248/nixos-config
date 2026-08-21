# UrBackup file backup client.
#
# Upstream builds resolve data/config directories from autoconf prefix,
# which on NixOS points into the read-only store and crashes the daemon
# (SQLite error 14). We override configureFlags to pin them to real
# filesystem locations:
#
#   --localstatedir=/var/lib  ->  /var/lib/urbackup   (StateDirectory)
#   --sysconfdir=/etc         ->  /etc/urbackup       (hook scripts)
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.urbackup-client;
in {
  options.services.urbackup-client = {
    enable = lib.mkEnableOption "UrBackup file backup client";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Open the ports the UrBackup server needs to reach this client:
        UDP 35622 (LAN discovery broadcast) and TCP 35414/35621/35623
        (client control and services).
      '';
    };

    firewallWifiNetworks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Open backup ports only while connected to one of these WiFi
        networks, matched against the NetworkManager connection profile
        name (equals the SSID for default profiles). Rules are added and
        removed by a NetworkManager dispatcher script.
      '';
    };

    serverIp = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Source IP of the UrBackup server used to scope firewall rules
        added by the WiFi dispatcher (firewallWifiNetworks mode only;
        static openFirewall cannot be scoped by source).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        urbackup-client = prev.urbackup-client.overrideAttrs (old: {
          configureFlags =
            (old.configureFlags or [])
            ++ [
              "--localstatedir=/var/lib"
              "--sysconfdir=/etc"
            ];

          # Redirect only the install phase: its rules try to create
          # /var/lib/urbackup directly, which fails in the build sandbox.
          installFlags = (old.installFlags or []) ++ [
            "localstatedir=$out/var/lib"
            "sysconfdir=$out/etc"
          ];

          # The install-phase redirect also corrupts path substitution in
          # the default list scripts (". \"ut/etc/...\"). Guard each
          # source line so missing optional configs don't abort the
          # script (which would disable file indexing).
          postFixup = ''
            for f in "$out/share/urbackup/scripts/list" "$out/share/urbackup/scripts/list_incr"; do
              sed -i 's@^\. "ut/etc/\(.*\)"$@[ -f "/etc/\1" ] \&\& . "/etc/\1" || true@' "$f"
            done
          '';
        });
      })
    ];

    environment.systemPackages = [
      pkgs.urbackup-client
    ];

    # Default file-listing scripts the daemon expects under sysconfdir.
    environment.etc."urbackup/scripts".source =
      "${pkgs.urbackup-client}/share/urbackup/scripts";

    # Ports the client actually binds (verified via ss):
    #   35622/udp discovery, 35414/tcp legacy control,
    #   35621/tcp + 35623/tcp client services.
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [
      35622
    ];
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      35414
      35621
      35623
    ];

    # Dynamic mode: a NetworkManager dispatcher script inserts ACCEPT
    # rules at the top of the INPUT chain while connected to an allowed
    # network and removes them otherwise. Uses the same iptables package
    # as the NixOS firewall so both see one consistent ruleset.
    networking.networkmanager.dispatcherScripts =
      lib.mkIf (cfg.firewallWifiNetworks != [])
        [
          {
            type = "basic";
            source = pkgs.writeText "urbackup-firewall-dispatcher" ''
              #!${pkgs.bash}/bin/bash
              set -u

              IFACE="$1"
              ACTION="$2"

              IPTABLES="${pkgs.iptables}/bin/iptables"
              NMCLI="${pkgs.networkmanager}/bin/nmcli"

              NETWORKS=(${lib.concatStringsSep " " (map (n: "'${n}'") cfg.firewallWifiNetworks)})
              SRC_ARGS=${lib.optionalString (cfg.serverIp != null) "-s ${cfg.serverIp}"}
              RULES=${lib.concatStringsSep " " (map (p: "'${p}'") [
                "udp --dport 35622"
                "tcp --dport 35414"
                "tcp --dport 35621"
                "tcp --dport 35623"
              ])}

              add_rules() {
                local r
                for r in ''${RULES[@]}; do
                  $IPTABLES -C INPUT -i "$IFACE" $SRC_ARGS -p $r -j ACCEPT 2>/dev/null || $IPTABLES -I INPUT 1 -i "$IFACE" $SRC_ARGS -p $r -j ACCEPT
                done
              }

              remove_rules() {
                local r
                for r in ''${RULES[@]}; do
                  while $IPTABLES -D INPUT -i "$IFACE" $SRC_ARGS -p $r -j ACCEPT 2>/dev/null; do :; done
                done
              }

              case "$ACTION" in
                up|dhcp4-change|connectivity-change)
                  CONN=$($NMCLI -g GENERAL.CONNECTION device show "$IFACE" 2>/dev/null || true)
                  MATCH=no
                  for net in ''${NETWORKS[@]}; do
                    [ "$CONN" = "$net" ] && MATCH=yes
                  done
                  if [ "$MATCH" = yes ]; then add_rules; else remove_rules; fi
                  ;;
                down|pre-down)
                  remove_rules
                  ;;
              esac
            '';
          }
        ];

    systemd.services.urbackup-client = {
      description = "UrBackup Client Backend";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.urbackup-client}/bin/urbackupclientbackend -v info";
        # Includes the data/ subdir: upstream chmods it unconditionally
        # at startup but never creates it (installers normally do).
        StateDirectory = "urbackup/data";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
