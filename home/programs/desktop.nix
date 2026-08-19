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
    libnotify
    playerctl
    wlogout
    sound-theme-freedesktop

    # Hyprland
    hypridle
    hyprlock
    hyprpaper
    brightnessctl

    # Terminal
    foot

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.code-new-roman
    inter

    # Tools
    system-config-printer
    bitwarden-desktop
    filezilla
  ];
}
