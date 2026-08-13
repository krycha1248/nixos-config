{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI
    screenfetch
    cowsay
    shellcheck
    ripgrep
    fd
    htop
    btop
    fzf
    jq
    yazi
    fastfetch
    tree
    curl
    wget
    usbutils

    # Archives
    unzip
    zip
  ];
}
