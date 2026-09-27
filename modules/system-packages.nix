{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sbctl
    cifs-utils
    curl
    nettools
    wget
    usbutils
    unzip
    zip
    _7zz
    alsa-utils
    wayland-utils
    wl-clipboard

    (ocrmypdf.override {
      tesseract = tesseract.override {
        enableLanguages = [
          "eng"
          "pol"
          "osd"
        ];
      };
    })
  ];
}
