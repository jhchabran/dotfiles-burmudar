{config, pkgs,...}:
{
  #programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.username = "william";

  home.file = let
    configHome = if pkgs.stdenv.isDarwin then config.home.homeDirectory else config.xdg.configHome;
    files =  {
    ".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink ../vim/init.lua;
    ".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink ../vim/lua;
    ".zwilliam".source = ../zsh/zwilliam;
    ".zwork".source = if pkgs.stdenv.isDarwin then ../zsh/zwork else builtins.toFile ".zwork" "# Purposely empty";
    "code/.keep".source = builtins.toFile ".keep" "";
    "${configHome}/qutebrowser/config.py".source = ../qutebrowser/config.py;
    "${config.xdg.configHome}/zk/config.toml".source = ../zk/config.toml;
    "${config.xdg.configHome}/zk/templates".source = ../zk/templates;
    };
  in
    if pkgs.stdenv.isDarwin then
      files // {
        "${config.home.homeDirectory}/.hammerspoon".source = ../hammerspoon;
      }
    else
      files // {};

  home.shellAliases = let
    systemCmd = if pkgs.stdenv.isDarwin then "./nix/result/sw/bin/darwin-rebuild switch --flake nix/." else "sudo nixos-rebuild switch --flake nix/.";
    in {
    pass="gopass";
    aenv="source $(fd -s 'activate')";
    denv="deactivate";
    grep="grep --color=auto";
    fgrep="fgrep --color=auto";
    egrep="egrep --color=auto";
    cat="bat";
    bb="bazel build";
    bt="bazel test";
    bq="bazel query";
    bc="bazel configure";
    hsw = "cd $SRC/dotfiles && home-manager switch --flake 'nix/#mac'; cd -";
    ssw = "cd $SRC/dotfiles && ${systemCmd}; cd -";
    zj = "zk new --no-input -g journal";
  };

  home.packages = with pkgs; [
    home-manager
    starship
    ripgrep
    lsd
    fd
    jq
    cheat
    tldr
    gping
    procs
    dog
    delta
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

    initExtra = let
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
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      vim-tmux-focus-events
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "cpu-usage ram-usage"
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-show-fahrenheit false
        '';
      }
    ];

    extraConfig = ''
      set -g renumber-windows on
      set-option -g visual-activity off
      set-option -g visual-bell off
      set-option -g visual-silence off

      # keybindings
      bind-key C-s set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
      bind-key -T root M-j run-shell $SRC/dotfiles/tmux/popupmx.sh
      bind-key -T root M-n run-shell $SRC/dotfiles/tmux/notes.sh
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
    '';
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks = {
      "media-pc.*" = {
        hostname = "media-pc.local";
        user = "william";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "mac" = {
        hostname = "Williams-MacBook-Pro.local";
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
        hostname = "william-desktop.local";
        identityFile = "~/.ssh/keys/burmkey.pvt";
      };
      "spotipi.local" = {
          user = "pi";
          hostname = "spotipi.local";
          identityFile = "~/.ssh//keys/burmkey.pvt";
      };
      "spotipi" = {
          user = "pi";
          hostname = "spotipi";
          identityFile = "~/.ssh/keys/burmkey.pvt";
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
    enable = true;
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

  # services
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableSshSupport = true;
    enableZshIntegration = true;

    defaultCacheTtl = 3600 * 4;
  };

}
