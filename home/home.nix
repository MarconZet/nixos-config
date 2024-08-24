{
  inputs,
  config,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
in {
  home.username = "marcin";
  home.homeDirectory = "/home/marcin";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;
  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  #nixpkgs.config = {
  #  allowUnfree = true;
  #  allowBroken = true;
  #};

  home.packages = with pkgs; [
    firefox
    #ultrastardx
    #teamspeak_client
    #jetbrains.idea-ultimate
    #discord
  ];

  home.file = {
  };

  wayland.windowManager.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
      ];
    };
  };

  programs.git = {
    enable = true;
    userEmail = "25779550+MarconZet@users.noreply.github.com";
    userName = "MarconZet";
  };

  programs.gh.enable = true;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/marcin/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables
}
