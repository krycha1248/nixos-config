{ pkgs, ... }:

{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-lastplace
      auto-pairs
      ale
      vim-code-dark
    ];

    extraConfig = builtins.readFile ../config/vim/vimrc;
  };
}
