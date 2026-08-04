{ config, lib, pkgs, ... }:

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
    kitty
    wofi
    waybar
    swaybg
    yazi
  ];

  xdg.configFile."hypr/hyprland.conf".source =
    ./config/hypr/hyprland.conf;

  xdg.configFile."hypr/hypridle.conf".source =
    ./config/hypr/hypridle.conf;

  xdg.configFile."hypr/hyprlock.conf".source =
    ./config/hypr/hyprlock.conf;

  home.activation.reloadHyprland = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
      ${pkgs.hyprland}/bin/hyprctl reload || true
    fi
  '';



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
