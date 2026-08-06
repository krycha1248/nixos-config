{ config, lib, pkgs, hyprdynamicmonitors, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/gh.nix
    ./programs/zsh.nix
    ./programs/vim.nix
  ];

  home.username = "krystian";
  home.homeDirectory = "/home/krystian";

  home.packages =
    (with pkgs; [
      # Browsers
      google-chrome

      # Editors
      vscode

      # CLI
      cowsay
      ripgrep
      fd
      fzf
      jq
      yazi
      fastfetch

      # DevOps
      terraform
      terraform-ls
      ansible
      ansible-lint

      # Archives
      unzip
      zip

      # Wayland
      wofi
      fuzzel
      waybar
      swaybg
      grim
      slurp
      mako
      libnotify
      playerctl
      wlogout

      # Terminal
      foot

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.code-new-roman
      inter

      # Apps
      thunderbird
      teams-for-linux
      kodi
      libreoffice-still
      discord
    ])
    ++ [
      hyprdynamicmonitors.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];


  xdg.configFile = {
    "hypr/hypridle.conf".source = ./config/hypr/hypridle.conf;
    "hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
    "hypr/hyprlock.conf".source = ./config/hypr/hyprlock.conf;
    "hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;
    "hypr/wallpaper.png".source = ./config/hypr/wallpaper.png;

    "wlogout".source = ./config/wlogout;
    "waybar".source = ./config/waybar;
    "fuzzel/fuzzel.ini".source = ./config/fuzzel/fuzzel.ini;
    "foot/foot.ini".source = ./config/foot/foot.ini;
    "mako/config".source = ./config/mako/config;
    "hyprdynamicmonitors".source = ./config/hyprdynamicmonitors;
  };

  home.file.".local/bin/power-profile" = {
    source = ./scripts/power-profile;
    executable = true;
  };

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
    autoEnable = false;

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
      "gtk-decoration-layout" = ":";
      "gtk-application-prefer-dark-theme" = true;
    };

    gtk4.extraConfig = {
      "gtk-decoration-layout" = ":";
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
  # Home Manager state version
  # ------------------------------------------------------------

  home.stateVersion = "26.05";
}
