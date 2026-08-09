{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Wayland
    quickshell
    poweralertd
    fuzzel
    waybar
    swaybg
    mako
    hyprshot
    swappy
    wl-clipboard
    libnotify
    playerctl
    wlogout
    sound-theme-freedesktop
    alsa-utils

    # Terminal
    foot

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.code-new-roman
    inter
  ];
}
