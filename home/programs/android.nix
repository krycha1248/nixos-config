{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Android
    android-studio
    android-tools
  ];
}
