{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    vscode
    thunderbird
    teams-for-linux
    libreoffice-still
    discord
    gimp
    winbox
    (kodi.withPackages (kodiPkgs: with kodiPkgs; [
      inputstream-adaptive
    ]))
  ];
}
