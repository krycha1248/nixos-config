{ pkgs, ... }:

{
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  environment.systemPackages = with pkgs; [
    gamemode
  ];
}
