# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      <home-manager/nixos>	
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
  boot.loader.grub.version = 2;

  networking.hostName = "william-desktop"; # Define your hostname.
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

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable the X11 windowing system.
  services.xserver = {
  	enable = true;
	layout = "za";

	videoDrivers = [ "nvidia" ];

	desktopManager = {
		xterm.enable = false;
		xfce = {
			enable = true;
			noDesktop = true;
			enableXfwm = false;
			};
		};
	displayManager = {
		gdm.enable = true;
		defaultSession = "xfce+i3";
		};

	windowManager.i3 = {
		enable = true;
		extraPackages = with pkgs; [ rofi dmenu i3status i3lock ];
		};
	};


  services.picom.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.william = {
    isNormalUser = true;
    description = "William Bezuidenhout";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.william = import /home/william/.config/nixpkgs/home.nix;

  nix.settings.trusted-users = [ "root" "william" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
#  nixpkgs.overlays = [
#  	(import (builtins.fetchTarball {
#	  url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
#	}))
#	];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  os-prober
  unstable.neovim
  curl
  cura
  wget
  git
  go_1_18
  python3
  direnv
  nix-direnv
  unstable.gopls
  htop
  zsh
  lua
  ripgrep
  bat
  fd
  nmap
  jq
  fzf
  tmux
  unstable.difftastic
  xclip
  unstable.starship
  kitty
  unzip
  unstable.discord
  tdesktop # telegram
  spotify
  aspell
  aspellDicts.en
  aspellDicts.en-computers
  aspellDicts.en-science
  man-pages
  man-pages-posix
  btrfs-progs
  gcc
  unstable.grub2
  unstable.flameshot
  gnumake
  pavucontrol
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nix.extraOptions = '' 
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
    '';
  nix.package = unstable.nixFlakes;
  environment.pathsToLink = [ "/share/nix-direnv" ];
  environment.shells = with pkgs; [ zsh ];

  programs.zsh.enable = true;	

  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

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
  services.openssh.enable = true;

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

}
