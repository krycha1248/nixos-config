{ pkgs, ... }:

{
  home.username = "krystian";
  home.homeDirectory = "/home/krystian";

  home.packages = with pkgs; [
    firefox
    neovim

    ripgrep
    fd
    fzf

    unzip
    zip

    jq
    fastfetch
  ];


  # ------------------------------------------------------------
  # Git
  # ------------------------------------------------------------

  programs.git = {
    enable = true;
    settings = {
      user.name = "Krystian Włodek";
      user.email = "krycha1248@gmail.com";
    };
  };


  # ------------------------------------------------------------
  # GH
  # ------------------------------------------------------------

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };


  # ------------------------------------------------------------
  # Shell
  # ------------------------------------------------------------

  programs.bash.enable = true;


  # ------------------------------------------------------------
  # Home Manager state version
  # ------------------------------------------------------------

  home.stateVersion = "26.05";
}
