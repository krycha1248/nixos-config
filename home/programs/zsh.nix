{ pkgs, ... }:

{
  home.packages = [
    pkgs.zsh-powerlevel10k
  ];

  home.file.".p10k.zsh" = {
    source = ../config/zsh/p10k.zsh;
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;

    autosuggestion = {
      enable = true;
      highlight = "fg=245";
    };

    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;

      plugins = [
        "git"
        "docker"
        "docker-compose"
        "colored-man-pages"
        "vi-mode"
      ];
    };

    shellAliases = {
      l = "ls -lah";
    };

    initContent = ''
      # Powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

      export TERM="xterm-256color"

      ZSH_DISABLE_COMPFIX=true

      ENABLE_CORRECTION="true"

      export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
      [Yes, No, Abort, Edit] "

      COMPLETION_WAITING_DOTS="true"

      # zsh-syntax-highlighting
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

      ZSH_HIGHLIGHT_STYLES[default]=none
      ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
      ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
      ZSH_HIGHLIGHT_STYLES[alias]=fg=white,bold
      ZSH_HIGHLIGHT_STYLES[builtin]=fg=white,bold
      ZSH_HIGHLIGHT_STYLES[function]=fg=white,bold
      ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
      ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
      ZSH_HIGHLIGHT_STYLES[commandseparator]=none
      ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
      ZSH_HIGHLIGHT_STYLES[path]=fg=228,underline
      ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
      ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
      ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
      ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
      ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
      ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
      ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
      ZSH_HIGHLIGHT_STYLES[assign]=none

      # Powerlevel10k configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}

