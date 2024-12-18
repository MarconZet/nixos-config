{pkgs, ...}: {
  home.packages = with pkgs; [
    swww
    wl-clipboard
    cliphist
    pavucontrol
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = builtins.readFile ./hypr/hyprland.conf;
  };

  programs.hyprlock = {
    enable = true;
    extraConfig = builtins.readFile ./hypr/hyprlock.conf;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = ./waybar/style.css;
    settings = [(pkgs.lib.trivial.importJSON ./waybar/config.json)];
  };

  programs.wofi = {
    enable = true;
    settings = pkgs.lib.trivial.importTOML ./wofi/config.toml;
    style = builtins.readFile ./wofi/style.css;
  };

  programs.alacritty = {
    enable = true;
    settings = pkgs.lib.trivial.importTOML ./alacritty/config.toml;
  };

  programs.foot.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";}
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
    ];
    commandLineArgs = ["--disable-gpu-compositing"];
  };
}
