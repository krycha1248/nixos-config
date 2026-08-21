{ pkgs, ... }:

{
  services.fwupd.enable = true;

  services.smartd.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
