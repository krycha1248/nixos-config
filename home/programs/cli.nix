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
    opencode
    bitwarden-cli

    # Archives
    unzip
    zip
  ];
}
