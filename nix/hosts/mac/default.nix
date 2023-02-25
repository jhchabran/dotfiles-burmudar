{ pkgs, ... }:
{
  users.users.william = {
  	home = /Users/william;
  };

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  nix.package = pkgs.nixFlakes;

  networking.dns = ["1.1.1.1" "8.8.8.8"];
  networking.knownNetworkServices = [ "Wi-Fi" "Ethernet Adaptor" "Thunderbolt Ethernet" ];

  services.tailscale = {
    enable = true;
    magicDNS.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
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
      "font-jetbrains-mono-nerd-font"
      "hammerspoon"
      "iina"
      "intellij-idea-ce"
      "kitty"
      "loom"
      "p4v"
      "perforce"
      "postico"
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
}
