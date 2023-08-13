# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./orbstack.nix
      ./lxd.nix
    ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # set in Home manager
  users.defaultUserShell = pkgs.zsh;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    curl
    fd
    gcc
    git
    gnumake
    htop
    jq
    lua
    man-pages
    man-pages-posix
    neovim
    nmap
    # language servers
    # qmk for flashing keyboard
    unzip
    wget
    xclip
  ];

  programs.zsh.enable = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "william" ];
    gc.automatic = true;
    optimise.automatic = true;
  };

  environment.shells = with pkgs; [ zsh ];

  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" ]; })
  ];

  services.cloudflare-dns-ip = {
    enable = true;
  };


  services.tailscale = {
    enable = true;
  };
  system.stateVersion = "23.05"; # Did you read the comment?

  # Needed otherwise we get some binaries complaining that they can't find glibc
  system.activationScripts.ldso = pkgs.lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

}
