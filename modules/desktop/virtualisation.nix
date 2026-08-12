{ lib, pkgs, ... }:

{
  # ------------------------------------------------------------
  # Docker & Virtualbox
  # ------------------------------------------------------------

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  nixpkgs.overlays = [
    (final: prev: {
      virtualbox = prev.virtualbox.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeBinaryWrapper ];
        postFixup = (oldAttrs.postFixup or "") + ''
          wrapProgram $out/bin/VirtualBox --set QT_SCALE_FACTOR 1.5
        '';
      });
    })
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  systemd.services.docker = {
    wantedBy = lib.mkForce [];
  };
}
