{ ... }:

{
  # ------------------------------------------------------------
  # Android development
  # ------------------------------------------------------------

  # Device access is handled by built-in systemd uaccess rules
  # (systemd >= 258); adb comes from home/programs/android.nix

  # Lets SDK components downloaded by Android Studio (adb, emulator,
  # gradle...) run unpatched binaries on NixOS
  programs.nix-ld.enable = true;
}
