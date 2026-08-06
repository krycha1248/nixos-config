{ config, ... }:

{
  imports = [
    ./programs/zsh.nix
    ./programs/vim.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";

  # ------------------------------------------------------------
  # Home Manager state version
  # ------------------------------------------------------------

  home.stateVersion = "26.05";
}
