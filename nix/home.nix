{ config, pkgs, lib, ... }:
rec {
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";

  home.username = "william";

  home.homeDirectory = if pkgs.stdenv.isDarwin then lib.mkForce "/Users/${home.username}" else lib.mkForce "/home/${home.username}";

  home.file =
    let
      configHome = if pkgs.stdenv.isDarwin then config.home.homeDirectory else config.xdg.configHome;
      files = {
        ".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink ../vim/init.lua;
        ".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink ../vim/lua;
        ".zwilliam".source = ../zsh/zwilliam;
        ".zwork".source = if pkgs.stdenv.isDarwin then ../zsh/zwork else builtins.toFile ".zwork" "# Purposely empty";
        "code/.keep".source = builtins.toFile ".keep" "";
        ".ssh/config.d/.keep".source = builtins.toFile ".keep" "";
        "${configHome}/${(if pkgs.stdenv.isDarwin then ".qutebrowser" else "qutebrowser")}/config.py".source = ../qutebrowser/config.py;
        "${config.xdg.configHome}/zk/config.toml".source = ../zk/config.toml;
        "${config.xdg.configHome}/zk/templates".source = ../zk/templates;
      };
    in
    if pkgs.stdenv.isDarwin then
      files // {
        "${config.home.homeDirectory}/.hammerspoon".source = ../hammerspoon;
      }
    else
      files // { };

  home.shellAliases =
    let
      systemCmd = if pkgs.stdenv.isDarwin then "./nix/result/sw/bin/darwin-rebuild switch --flake nix/." else "sudo nixos-rebuild switch --flake nix/.";
    in
    {
      pass = "gopass";
      aenv = "source $(fd -s 'activate')";
      denv = "deactivate";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      cat = "bat";
      bb = "bazel build";
      bt = "bazel test";
      bq = "bazel query";
      bc = "bazel configure";
      hsw = "cd $SRC/dotfiles && home-manager switch --flake 'nix/#mac'; cd -";
      ssw = "cd $SRC/dotfiles && ${systemCmd}; cd -";
      zj = "zk new --no-input -g journal";
    };

  home.packages = with pkgs; [
    cheat
    delta
    dogdns
    fd
    gping
    jq
    lsd
    procs
    ripgrep
    starship
    tldr
  ];

  xdg = {
    enable = true;
  };
  # software
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "ansi";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      nodejs.disabled = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.k9s = {
    enable = true;
  };

  # commented out: qutebrowser has a broken dependency aka python310.readability-lxml
  # programs.qutebrowser = {
  #   enable = true;
  #   extraConfig = (builtins.readFile ../qutebrowser/config.py);
  # };



  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # extraConfig = ''
    # '';
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch = {
      enable = true;
    };
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    enableCompletion = true;

    envExtra = ''
      export SRC=~/code
      export ZK_NOTEBOOK_DIR=~/code/notes
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8
      export TERM=xterm-256color

      export VISUAL="nvim"
      export EDITOR="nvim"
    '';

    initExtra =
      let
        base = ''
          setopt EXTENDED_GLOB
          source ~/.zwilliam
          source ~/.zwork
        '';
      in
      if pkgs.stdenv.isDarwin then
        ''
          ${base}
          source ~/.cargo/env
        ''
      else
        base;

  };

  programs.tmux = {
    enable = true;

    clock24 = true;
    baseIndex = 1;
    escapeTime = 50;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    shortcut = "b";
    prefix = "C-a";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      vim-tmux-focus-events
    ];

    extraConfig = ''
      set -g renumber-windows on
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off
      set-option -sa terminal-features ',xterm-256color:RGB'

      # keybindings
      bind-key C-s set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
      bind-key -T root M-j run-shell $SRC/dotfiles/tmux/popupmx.sh
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # without this, vim scrolling lags
      set-option -s escape-time 10
    '';
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    includes = [
      "~/.ssh/config.d/*"
    ];
    matchBlocks = {
      "media-pc.*" = {
        hostname = "media-pc.lan";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "mac" = {
        hostname = "Williams-MacBook-Pro.lan";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "router" = {
        user = "root";
        hostname = "192.168.1.1";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "desktop" = {
        user = "william";
        hostname = "william-desktop.lan";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "spotipi.lan" = {
        user = "pi";
        hostname = "spotipi.lan";
        identityFile = "~/.ssh//keys/burmkey.pvt";
      };
      "bezuidenhout" = {
        user = "bezuidenhout";
        hostname = "bezuidenhout-pc";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
    };
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.git = {
    enable = true;
    userEmail = if pkgs.stdenv.isDarwin then "william.bezuidenhout@sourcegraph.com" else "william.bezuidenhout+github@gmail.com";
    userName = "William Bezuidenhout";
    signing = {
      signByDefault = true;
      key = "EDE8072F89D58CD9!";
    };
    aliases = {
      s = "status";
      co = "checkout";
      c = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      nb = "switch -c";
      ps = "push";
      psf = "push --force";
      psu = "push -u";
      pl = "pull";
      plr = "pull --rebase";
      f = "fetch";
      ap = "add -p";
    };
    extraConfig = {
      push.autoSetupRemote = true;
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
      };
    };
  };

  programs.alacritty = {
    enable = false;
    package = pkgs.alacritty;
    settings = {
      window = {
        decorations = "none";
        padding = { x = 2; y = 2; };
        startup_mode = "Maximized";
        dynamic_title = true;
        option_as_alt = "OnlyLeft";
      };
      font = {
        size = if pkgs.stdenv.isDarwin then 12.0 else 10.00;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Medium";
        };
      };
    };
  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    theme = "Dracula";
    font = {
      package = with pkgs; (nerdfonts.override { fonts = [ "FiraCode" ]; });
      name = "FiraCode Nerd Font Mono";
      size = 13.0;
    };
    keybindings = {
      "cmd+k>w" = "close_tab";
      "cmd+w" = "no-op";
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };
    settings = {
      input_delay = 2;
      sync_to_monitor = true;
      enable_audio_bell = false;
      macos_option_as_alt = true;
      macos_titlebar_color = "background";
      hide_window_decorations = true;
      open_url_modifiers = "cmd";
      tab_bar_style = "powerline";
      tab_bar_separator = " ";
      tab_bar_background = "none";
      shell_integration = true;

      copy_on_select = true;
    };
    extraConfig = ''
      macos_thicken_font 0.4
      window_padding_width 2.0
    '';
  };

  # services
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableSshSupport = true;
    enableZshIntegration = true;

    defaultCacheTtl = 3600 * 4;
  };
}
