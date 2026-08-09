{ pkgs, hyprdynamicmonitors, ... }:

{
  home.packages = [
    hyprdynamicmonitors.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."hyprdynamicmonitors".source =
    ../config/hyprdynamicmonitors;
}
