{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.supportedFilesystems = [ "ntfs" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "media-pc"; # Define your hostname.
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
  console = {
    font = "Lat2-Terminus16";
  };

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.nvidiaSettings = true;

  # Enable the X11 windowing system.
  services.xserver = {
  	enable = true;

    videoDrivers = [ "nvidia" ];

    desktopManager = {
      xterm.enable = false;
      gnome = {
      	enable = true;
	# Override GNOME defaults to disable GNOME tour and disable suspend
        extraGSettingsOverrides = ''
          [org.gnome.shell]
          welcome-dialog-last-shown-version='9999999999'
          [org.gnome.desktop.session]
          idle-delay=0
          [org.gnome.settings-daemon.plugins.power]
          sleep-inactive-ac-type='nothing'
          sleep-inactive-battery-type='nothing'
        '';
      };
    };
    displayManager = {
        autoLogin = {
          user = "william";
          enable = true;
        };
      lightdm = {
        enable = true;

      };
    };
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # set in Home manager
  users.defaultUserShell = pkgs.zsh;
  users.users.william = {
    isNormalUser = true;
    description = "William Bezuidenhout";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    hashedPassword = "$6$FMTzPpwTEQLk5Tkd$/7F7iOfqsA5zOVGTl7wic5jQHXmqsZqmLucRl0IxT0/Kx4JfGq.VrJreq4RLcqxhsbEJjKDf4fTdvPVWhjGr8/";
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6iuO9BMUxIaDlnUbRjPAi4d44nvEL4mSbTqUWAw53xEC9tRKGi7HxXBGVZzT6riDBdaI5Kibxj4fWMt3SMnSbxSjFOleS7iNRjjKyEGUnnpekVCHtye2tNDaRvnKwK4/ZG8Kd/t/aKYyWmPZJEVfWUM3iiFgBHh/3ml0Zgb/Y0QCxP7FdIyCeMY3f8AW6wGVfNH3BBvRlpQt+rNwYmp/kmsrxalgUGpzHOlpKQbzh+0Ox5I73RF+nK7VBJA6OAan6n7zyfy40y/LwQieckqbi2Jogd438G8iqnQYkIXFCMV8IFCQ4wjAnDvdfOBysdKlxwS+1ZNHv0UGHT4jbRw0N william.bezuidenhout+ssh@gmail.com"];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  aspell
  aspellDicts.en
  aspellDicts.en-computers
  aspellDicts.en-science
  bash
  btrfs-progs
  curl
  fd
  firefox
  flameshot
  gcc
  git
  gnumake
  go
  htop
  jq
  kitty
  lua
  man-pages
  man-pages-posix
  mkpasswd
  neovim
  nmap
  pavucontrol
  pipewire
  python3
  spotify
  tmux
  unzip
  vlc
  wget
  xclip
  ];

  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      settings.trusted-users = [ "root" "william" ];
      gc.automatic = true;
      optimise.automatic = true;
  };

  environment.shells = with pkgs; [ zsh ];

  fonts.fonts = with pkgs; [
  	noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "Hack" "JetBrainsMono" ]; })
  ];

  services.avahi = {
  	enable = true;
    nssmdns = true;
    publish = {
      addresses = true;
      domain = true;
      enable = true;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh= {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };



  # Enable docker daemon to start
  virtualisation.docker.enable = true;
  #virtualisation.docker.storageDriver = "btrfs";


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  # Stop Gnome 3 from suspending
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Needed otherwise we get some binaries complaining that they can't find glibc
  system.activationScripts.ldso = pkgs.lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';
}
