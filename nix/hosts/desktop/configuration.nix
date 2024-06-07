# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }@inputs:
let
in {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./ergodox.nix
    ];

  boot.supportedFilesystems = [ "ntfs" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "fort-kickass"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.nvidiaSettings = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "za";
    };

    videoDrivers = [ "nvidia" ];

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ rofi dmenu polybarFull i3lock ];
    };

    displayManager = {
      lightdm = {
        enable = true;
      };
      defaultSession = "xfce+i3";
    };
  };


  services.picom.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.noisetorch = {
    enable = true;
  };
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Additional plugins for Thunar
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  # Needed for Thunar to function properly
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # set in Home manager
  users.defaultUserShell = pkgs.zsh;
  users.users.william = {
    isNormalUser = true;
    description = "William Bezuidenhout";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "libvirtd" "wireshark" "tty" "dialout" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6iuO9BMUxIaDlnUbRjPAi4d44nvEL4mSbTqUWAw53xEC9tRKGi7HxXBGVZzT6riDBdaI5Kibxj4fWMt3SMnSbxSjFOleS7iNRjjKyEGUnnpekVCHtye2tNDaRvnKwK4/ZG8Kd/t/aKYyWmPZJEVfWUM3iiFgBHh/3ml0Zgb/Y0QCxP7FdIyCeMY3f8AW6wGVfNH3BBvRlpQt+rNwYmp/kmsrxalgUGpzHOlpKQbzh+0Ox5I73RF+nK7VBJA6OAan6n7zyfy40y/LwQieckqbi2Jogd438G8iqnQYkIXFCMV8IFCQ4wjAnDvdfOBysdKlxwS+1ZNHv0UGHT4jbRw0N william.bezuidenhout+ssh@gmail.com" ];

  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bash
    btrfs-progs
    cura
    curl
    difftastic
    fd
    flameshot
    gcc
    git
    gnumake
    inputs.unstable.go
    inputs.unstable.gopls
    grub2
    htop
    jq
    kitty
    krita
    lua
    man-pages
    man-pages-posix
    inputs.unstable.neovim
    nil
    nix-direnv
    nmap
    nodePackages.typescript-language-server
    nodejs_20
    os-prober
    openssl.dev
    inputs.unstable.obsidian
    pavucontrol
    pipewire
    pkg-config
    python3
    qmk
    inputs.unstable.qutebrowser
    racket
    rust-bin.stable.latest.default
    spotify
    sumneko-lua-language-server
    tdesktop # telegram
    tmux
    unzip
    vlc
    wget
    where-is-my-sddm-theme
    xclip
    zk
  ];

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.trusted-users = [ "root" "william" ];
    gc.automatic = true;
    optimise.automatic = true;
  };

  environment.pathsToLink = [ "/share/nix-direnv" ];
  environment.shells = with pkgs; [ zsh ];

  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  programs.steam = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" ]; })
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      addresses = true;
      domain = true;
      enable = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.tailscale = {
    enable = true;
  };

  # Enable docker daemon to start
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Enable virtualbox
  virtualisation.virtualbox.host.enable = true;

  # Enable libvirt/kvm
  virtualisation.libvirtd.enable = true;


  # Need so that qmk can see the keyboard
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Needed otherwise we get some binaries complaining that they can't find glibc
  system.activationScripts.ldso = pkgs.lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

}
