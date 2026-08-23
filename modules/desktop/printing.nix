{ pkgs, ... }:

{
  services.printing = {
    enable = true;

    drivers = with pkgs; [
      gutenprint
      hplipWithPlugin
    ];
  };

  # Scanner support (SANE)
  hardware.sane = {
    enable = true;

    extraBackends = with pkgs; [
      hplipWithPlugin # HP (hpaio)
      sane-airscan # driverless scanning over network (eSCL/WSD)
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
