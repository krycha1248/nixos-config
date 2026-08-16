{ pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  networking.firewall.enable = true;

  security.pki.certificateFiles = [
    ../certs/wlodek-lan-root-ca.crt
  ];
}
