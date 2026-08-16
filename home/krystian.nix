{ config, lib, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/gh.nix
    ./programs/zsh.nix
    ./programs/vim.nix
    ./programs/udiskie.nix

    ./programs/apps.nix
    ./programs/cli.nix
    ./programs/devops.nix
    ./programs/desktop.nix
    ./programs/media.nix
    ./programs/hyprdynamicmonitors.nix

    ./services/desktop.nix
  ];

  home.username = "krystian";
  home.homeDirectory = "/home/krystian";

  # ------------------------------------------------------------
  # Stylix
  # ------------------------------------------------------------

  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    polarity = "dark";

    cursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 24;
    };

    fonts = {
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      serif = {
        package = pkgs.inter;
        name = "Inter";
      };

      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
    };
  };

  gtk = {
    theme = lib.mkForce {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };


  home.sessionVariables = {
    QT_WAYLAND_DISABLE_WINDOWDECORATION=1;
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  # ------------------------------------------------------------
  # XDG config files
  # ------------------------------------------------------------

  xdg.configFile = {
    "hypr/hypridle.conf".source =
      ./config/hypr/hypridle.conf;

    "hypr/hyprland.conf".source =
      ./config/hypr/hyprland.conf;

    "hypr/hyprlock.conf".source =
      ./config/hypr/hyprlock.conf;

    "hypr/hyprpaper.conf".source =
      ./config/hypr/hyprpaper.conf;

    "hypr/wallpaper.png".source =
      ./config/hypr/wallpaper.png;

    "quickshell/shell.qml".source =
      ./config/quickshell/shell.qml;

    "wlogout".source =
      ./config/wlogout;

    "waybar".source =
      ./config/waybar;

    "fuzzel/fuzzel.ini".source =
      ./config/fuzzel/fuzzel.ini;

    "foot/foot.ini".source =
      ./config/foot/foot.ini;

    "mako/config".source =
      ./config/mako/config;
  };

  # ------------------------------------------------------------
  # Local scripts
  # ------------------------------------------------------------

  home.file = {
    ".local/bin/power-profile" = {
      source = ./scripts/power-profile;
      executable = true;
    };
  };

  # ------------------------------------------------------------
  # Hyprland
  # ------------------------------------------------------------

  home.activation.reloadHyprland =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
        ${pkgs.hyprland}/bin/hyprctl reload || true
      fi
    '';

  # ------------------------------------------------------------
  # XDG user directories
  # ------------------------------------------------------------

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop =
      "${config.home.homeDirectory}/Desktop";

    documents =
      "${config.home.homeDirectory}/Documents";

    download =
      "${config.home.homeDirectory}/Downloads";

    music =
      "${config.home.homeDirectory}/Music";

    pictures =
      "${config.home.homeDirectory}/Pictures";

    publicShare =
      "${config.home.homeDirectory}/Public";

    templates =
      "${config.home.homeDirectory}/Templates";

    videos =
      "${config.home.homeDirectory}/Videos";
  };

  # ------------------------------------------------------------
  # Polkit
  # ------------------------------------------------------------

  services.polkit-gnome = {
    enable = true;
  };

  # ------------------------------------------------------------
  # Home Manager
  # ------------------------------------------------------------

  home.stateVersion = "26.05";
}
