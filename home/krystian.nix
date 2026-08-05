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
    wofi
    waybar
    swaybg
    yazi
    nerd-fonts.jetbrains-mono
    inter

    fuzzel
    foot
    grim
    slurp
    playerctl
    mako
    libnotify
    thunderbird
    google-chrome
    teams-for-linux
  ];

  home.file = {
    ".config/hypr" = {
        source = ./config/hypr;
        recursive = true;
    };
    ".config/wlogout" = {
        source = ./config/wlogout;
        recursive = true;
    };
    ".config/waybar" = {
        source = ./config/waybar;
        recursive = true;
    };
  };

  xdg.configFile."fuzzel/fuzzel.ini".source =
    ./config/fuzzel/fuzzel.ini;

  xdg.configFile."foot/foot.ini".source =
    ./config/foot/foot.ini;

  xdg.configFile."mako/config".source =
    ./config/mako/config;

  home.file.".local/bin/power-profile".source =
    ./scripts/power-profile;

  home.activation.reloadHyprland = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
      ${pkgs.hyprland}/bin/hyprctl reload || true
    fi
  '';


  xdg.userDirs = {
    enable = true;

    createDirectories = true;

    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
  };

  services.hyprpolkitagent = {
    enable = true;
  };

  catppuccin = {
    enable = true;

    flavor = "mocha";
    accent = "blue";

    gtk = {
      icon = {
        enable = true;
        flavor = "mocha";
        accent = "blue";
      };
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Inter";
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };

    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;

    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 24;
  };


  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };


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
