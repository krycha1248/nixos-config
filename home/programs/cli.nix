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
    fzf
    jq
    yazi
    fastfetch
    tree
    curl
    wget

    # Archives
    unzip
    zip
  ];
}
