{ pkgs, unstable, ... }:

{
  home.packages = [
    (unstable.bottles.override { removeWarningPopup = true; })
  ];
}
