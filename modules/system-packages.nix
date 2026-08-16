{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sbctl
    cifs-utils
    curl
    wget
    usbutils
    unzip
    zip
    alsa-utils
    wayland-utils
    wl-clipboard
  ];
}
