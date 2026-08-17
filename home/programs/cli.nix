{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI
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
    cowsay
    goose-cli

    # Archives
    unzip
    zip
  ];
}
