{ pkgs, ... }:
{

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  services.nix-daemon.package = pkgs.nixFlakes;

  # if you use zsh (the default on new macOS installations),
  # you'll need to enable this so nix-darwin creates a zshrc sourcing needed environment changes
  programs.zsh.enable = true;
  # bash is enabled by default

  homebrew = {
    enable = true;
    autoUpdate = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "1password"
      "1password-cli"
      "amethyst"
      "calibre"
      "chromium"
      "discord"
      "docker"
      "firefox"
      "firefox"
      "font-jetbrains-mono-nerd-font"
      "hammerspoon"
      "iina"
      "intellij-idea-ce"
      "kitty"
      "licecap"
      "logseq"
      "loom"
      "p4v"
      "perforce"
      "postico"
      "qutebrowser"
      "raycast"
      "skype"
      "slack"
      "spotify"
      "steam"
      "sublime-merge"
      "tailscale"
      "telegram-desktop"
      "vlc"
      "zoom"
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.william = import ../../home.nix
}
