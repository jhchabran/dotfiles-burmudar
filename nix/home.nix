{config, pkgs, ...}:

{
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.file = {
    ".config/nvim/".source = ../vim;
    ".zwilliam".source = ../zsh/zwilliam;
    ".zwork".source = if pkgs.stdenv.isDarwin then ../zsh/zwork else builtins.toFile ".zwork" "# Purposely empty";

    "code/.keep".source = builtins.toFile ".keep" "";
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
      name = "github";
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
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export TERM=xterm-256color

    export VISUAL="nvim"
    export EDITOR="nvim"
    '';

    initExtra = ''
      source ~/.zwilliam
      source ~/.zwork
    '';
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
          set -g @dracula-plugins "cpu-usage ram-usage weather"
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
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
    '';
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  # services
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableSshSupport = true;
    enableZshIntegration = true;

    defaultCacheTtl = 3600 * 4;
  };
}
