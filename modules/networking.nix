{ pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  networking.firewall.enable = true;
  services.resolved.enable = true;

  security.pki.certificateFiles = [
    ../certs/wlodek-lan-root-ca.crt
  ];

  services.netbird.clients.wt0 = {
    ui.enable = true;
    port = 51821;
  };
}
