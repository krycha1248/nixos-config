{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    imv
    mpv
    termusic
    spotify
    easyeffects
  ];

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
