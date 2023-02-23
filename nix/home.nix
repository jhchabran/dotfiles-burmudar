{ pkgs, ...}: {
   home.stateVersion = "22.11";

   # software
   programs.direnv = {
    enable = true;
    enableZshIntegration = true;
   };

   programs.bat = {
    enable = true;
   };

   programs.starship = {
    enable = true;
   };

   programs.fzf = {
    enable = true;
    enableZshIntegration = true;
   };

   programs.zsh = {
    enable = true;
    # initExtra = ''
    # source ~/.zwilliam
    # '';
   };
}
