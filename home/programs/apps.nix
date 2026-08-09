{ pkgs, ... }:

{
  home.packages = with pkgs; [
    google-chrome
    vscode
    thunderbird
    teams-for-linux
    kodi
    libreoffice-still
    discord
    winbox
  ];
}
