{
  inputs,
  config,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
  colors = import ./colors.nix {};
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
    systemd.enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
      ];
    };
  };

  programs.waybar = with colors; {
    enable = true;
    systemd.enable = true;
    style = ''
      window#waybar {
        background-color: #${background};
        color: #${foreground};
        border-bottom: none;
      }
      #workspaces {
        font-family: "Material Design Icons Desktop";
        font-size: 20px;
        background-color: #${mbg};
        margin : 4px 0;
        border-radius : 5px;
      }
      #workspaces button {
        font-size: 18px;
        background-color: transparent;
        color: #${color5};
        transition: all 0.1s ease;
      }
      #workspaces button.focused {
        font-size: 18px;
        color: #${color3};
      }
      #workspaces button.persistent {
        color: #${color1};
        font-size: 12px;
      }
      #custom-launcher {
        background-color: #${mbg};
        color: #${color4};
        margin : 4px 4.5px;
        padding : 5px 12px;
        font-size: 18px;
        border-radius : 5px;
      }
      #custom-power {
        color : #${color1};
        background-color: #${mbg};
        margin : 4px 4.5px 4px 4.5px;
        padding : 5px 11px 5px 13px;
        border-radius : 5px;
      }

      #clock {
        background-color: #${mbg};
        color: #${color7};
        margin : 4px 9px;
        padding : 5px 12px;
        border-radius : 5px;
      }

      #network {
        color : #${color7};
        background-color: #${mbg};
        margin : 4px 0 4px 4.5px;
        padding : 5px 12px;
        border-radius : 5px 0 0 5px;
      }
      #battery {
        color : #${color2};
        background-color: #${mbg};
        margin : 4px 0px;
        padding : 5px 12px;
        border-radius : 5px 0 0 5px;
      }
      #custom-swallow {
        background-color: #${mbg};
        margin : 4px 4.5px;
        padding : 5px 12px;
        border-radius : 5px;
      }
      * {
        font-size: 16px;
        min-height: 0;
        font-family: "Iosevka Nerd Font", "Material Design Icons Desktop";
      }
    '';
    settings = [
      {
        height = 35;
        layer = "top";
        position = "top";
        tray = {spacing = 10;};
        modules-center = ["clock"];
        modules-left = ["custom/launcher" "hyprland/workspaces"];
        modules-right = [
          "network"
          "battery"
          "custom/power"
          "tray"
        ];
        "hyprland/workspaces" = {
          on-click = "activate";
          all-outputs = true;
          format = "{icon}";
          disable-scroll = true;
          active-only = false;
          format-icons = {
            default = "󰊠 ";
            persistent = "󰊠 ";
            focused = "󰮯 ";
          };
          persistent_workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };
        battery = {
          format = "{icon}";
          on-click = "eww open --toggle control";
          format-charging = " ";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-plugged = "󰚦 ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = "{:%d %A %H:%M}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        network = {
          interval = 1;
          on-click = "eww open --toggle control";
          format-disconnected = "󰤮 ";
          format-wifi = "󰤨 ";
        };
        "custom/launcher" = {
          on-click = "eww open --toggle dash";
          format = " ";
        };
        "custom/power" = {
          on-click = "powermenu &";
          format = " ";
        };
      }
    ];
  };

  programs.kitty = {
    enable = true;
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
