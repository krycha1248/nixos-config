{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Terraform
    terraform
    terraform-ls

    # Ansible
    ansible
    ansible-lint

    # Docker
    lazydocker

    # Nodejs
    nodejs
    pnpm
  ];
}
