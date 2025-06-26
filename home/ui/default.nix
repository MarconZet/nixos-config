{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    pavucontrol
    evtest
    hyprshot
    ddcutil
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

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = ["~/nixos/images/wayland_anime_4K.png"];
      wallpaper = [" , ~/nixos/images/wayland_anime_4K.png"];
    };
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
    enable = false;
    settings = pkgs.lib.trivial.importTOML ./alacritty/config.toml;
  };

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.jetbrains-mono;
      name = "Jetbrains Mono";
      size = 12;
    };
    keybindings = {
    };
    settings = {
      kitty_mod = "cmd";
      enable_audio_bell = false;
      update_check_interval = 0;
      scrollback_lines = 10000;
      background_opacity = 0.95;
      background = "#1d2021";
      foreground = "#c5c8c6";
      confirm_os_window_close = 0;
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      {id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";}
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
      {id = "lcpclaffcdiihapebmfgcmmplphbkjmd";}
    ];
    commandLineArgs = ["--disable-gpu-compositing"];
  };

  xdg = {
    enable = true;
    desktopEntries = {
      discord = {
        name = "Discord";
        exec = "discord --disable-gpu";
        genericName = "Internet Messenger";
        comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
        categories = ["Network" "InstantMessaging"];
        icon = "discord";
        settings = {
          StartupWMClass = "discord";
        };
      };
    };
  };
}
