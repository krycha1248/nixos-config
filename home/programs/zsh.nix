{ config, lib, pkgs, host, ... }:

{
  home.packages = [
    pkgs.zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ../config/zsh/p10k.zsh;

  programs.zsh = {
    enable = true;

    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
      highlight = "fg=245";
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" ];
    };

    oh-my-zsh = {
      enable = true;

      theme = "powerlevel10k/powerlevel10k";

      custom = "${pkgs.zsh-powerlevel10k}/share/zsh/themes";

      plugins = [
        "git"
        "docker"
        "docker-compose"
        "colored-man-pages"
        "vi-mode"
      ];
    };

    shellAliases =
      {
        # ------------------------------------------------------------
        # Files
        # ------------------------------------------------------------

        l = "ls -lah";
      }
      // lib.mkIf (config.home.username == "krystian") {
        # ------------------------------------------------------------
        # NixOS
        # ------------------------------------------------------------

        ns =
          "sudo nixos-rebuild switch --flake ~/nixos#${host}";

        nt =
          "sudo nixos-rebuild test --flake ~/nixos#${host}";

        nb =
          "sudo nixos-rebuild boot --flake ~/nixos#${host}";

        # ------------------------------------------------------------
        # Flake
        # ------------------------------------------------------------

        nfu =
          "nix flake update --flake ~/nixos";

        nfc =
          "nix flake check --flake ~/nixos";

        # ------------------------------------------------------------
        # Update + rebuild
        # ------------------------------------------------------------

        nsu =
          "nix flake update --flake ~/nixos"
          + " && "
          + "sudo nixos-rebuild switch --flake ~/nixos#${host}";


        nbu =
          "nix flake update --flake ~/nixos"
          + " && "
          + "sudo nixos-rebuild boot --flake ~/nixos#${host}";

        # ------------------------------------------------------------
        # Garbage collection
        # ------------------------------------------------------------

        ngc =
          "sudo nix-collect-garbage -d";
      };

    initContent = lib.mkMerge [
      (lib.mkOrder 500 ''
        ZSH_DISABLE_COMPFIX=true

        ENABLE_CORRECTION="true"

        COMPLETION_WAITING_DOTS="true"

        export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [Yes, No, Abort, Edit] "
      '')

      (lib.mkOrder 1000 ''
        export TERM="xterm-256color"

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        ${lib.optionalString (config.home.username == "krystian") ''
          _nixos_cowsay_once() {
            add-zsh-hook -d precmd _nixos_cowsay_once
            cowsay "Deploying directly to production builds character."
            echo
          }
          add-zsh-hook precmd _nixos_cowsay_once
        ''}
      '')
    ];
  };
}
