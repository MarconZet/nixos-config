{pkgs, ...}: {
  home.username = "marcin";
  home.homeDirectory = "/home/marcin";
  programs.home-manager.enable = true;
  #nixpkgs.config = {
  #  allowUnfree = true;
  #  allowBroken = true;
  #};
  imports = [
    (import ./ui {inherit pkgs;})
  ];

  programs.git = {
    enable = true;
    userEmail = "25779550+MarconZet@users.noreply.github.com";
    userName = "MarconZet";
  };

  programs.gh.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    #autosuggestion.async = true;
    #enableGlobalCompInit = true;
    syntaxHighlighting.enable = true;
    history.size = 1000000;
    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "af-magic";
    oh-my-zsh.plugins = ["git"];
    shellAliases = {
      nrs = "~/nixos/home/scripts/rebuild.sh";
      rw = "~/nixos/home/scripts/boot_to_windows.sh";
    };
  };
}
