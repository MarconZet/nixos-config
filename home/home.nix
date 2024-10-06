{
  inputs,
  config,
  pkgs,
  ...
}: let
  #  hyprland = inputs.hyprland;
  #  hyprland-plugins = inputs.hyprland-plugins;
in {
  home.username = "marcin";
  home.homeDirectory = "/home/marcin";
  home.stateVersion = "24.05"; # Please read the comment before changing.
  programs.home-manager.enable = true;
  #nixpkgs.config = {
  #  allowUnfree = true;
  #  allowBroken = true;
  #};

  home.packages = with pkgs; [
    swww
    wl-clipboard
    cliphist
    pavucontrol
    teamspeak_client
    jetbrains.idea-ultimate
    discord
    starsector
    apple-cursor
  ];

  programs.git = {
    enable = true;
    userEmail = "25779550+MarconZet@users.noreply.github.com";
    userName = "MarconZet";
  };

  programs.gh.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    extraConfig = builtins.readFile ./ui/hypr/hyprland.conf;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = ./ui/waybar/style.css;
    settings = [(pkgs.lib.trivial.importJSON ./ui/waybar/config.json)];
  };

  programs.wofi = {
    enable = true;
    settings = pkgs.lib.trivial.importTOML ./ui/wofi/config.toml;
    style = builtins.readFile ./ui/wofi/style.css;
  };

  programs.alacritty = {
    enable = true;
    settings = pkgs.lib.trivial.importTOML ./ui/alacritty/config.toml;
  };

  programs.foot = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";}
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
    ];
  };
}
