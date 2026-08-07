{ pkgs, host, ... }:

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

shellAliases = {
  # Files
  l = "ls -lah";

  # NixOS
  ns = "sudo nixos-rebuild switch --flake /etc/nixos#${host}";
  nst = "sudo nixos-rebuild test --flake /etc/nixos#${host}";
  nsb = "sudo nixos-rebuild boot --flake /etc/nixos#${host}";

  # Flake
  nfu = "nix flake update --flake /etc/nixos";
  nfc = "nix flake check --flake /etc/nixos";

  # Update + rebuild
  nsu =
    "nix flake update --flake /etc/nixos"
    + " && "
    + "sudo nixos-rebuild switch --flake /etc/nixos#${host}";

  # Garbage collection
  ngc = "sudo nix-collect-garbage -d";
};


    initContent = ''
      export TERM="xterm-256color"

      ZSH_DISABLE_COMPFIX=true

      ENABLE_CORRECTION="true"

      export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
      [Yes, No, Abort, Edit] "

      COMPLETION_WAITING_DOTS="true"

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
