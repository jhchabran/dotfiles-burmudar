{
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.users.william = { pkgs, ...}: {
    home.stateVersion = "22.11";

    home.file = {
      ".config/nvim/".source = ../vim;
      ".zwilliam".source = ../zsh/zwilliam;
      "code-test/".source = builtins.toFile ".keep" "";
    };

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
      '';
    };

    # services
    services.gpg-agent = {
      enable = pkgs.stdenv.isLinux;
      enableSshSupport = true;
      enableZshIntegration = true;

      defaultCacheTtl = 3600 * 4;
    };
  };
}
