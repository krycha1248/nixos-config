{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sbctl
    cifs-utils
    curl
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
