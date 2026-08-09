{ pkgs, ... }:

{
  home.packages = with pkgs; [
    imv
    mpv
    termusic
    spotify
  ];
}
