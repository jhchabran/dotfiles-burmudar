{config, pkgs, ...}:

{
  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

  home.file = {
    ".config/nvim/".source = ../vim;
    ".zwilliam".source = ../zsh/zwilliam;
    ".zwork".source = if pkgs.stdenv.isDarwin then ../zsh/zwork else builtins.toFile ".zwork" "empty";

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
