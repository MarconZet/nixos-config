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

  wayland.windowManager.hyprland = with colors; {
    enable = true;
    systemd.enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    extraConfig = ''
      $mainMod = SUPER
      bind = CTRL, Q, exec, kitty
      bind = CTRL, W, exec, kitty
      bind = CTRL, F, exec, firefox
      monitor=,preferred,auto,1
      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options = caps:escape
        kb_rules =
        follow_mouse = 1 # 0|1|2|3
        float_switch_override_focus = 2
        numlock_by_default = true
        touchpad {
        natural_scroll = yes
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }
      general {
        gaps_in = 20
        gaps_out = 20
        border_size = 0
        col.active_border = rgb(${accent})
        col.inactive_border = rgba(595959aa)
        layout = dwindle # master|dwindle
      }
      dwindle {
        no_gaps_when_only = false
        force_split = 0
        special_scale_factor = 0.8
        split_width_multiplier = 1.0
        use_active_for_splits = true
        pseudotile = yes
        preserve_split = yes
      }
      # cursor_inactive_timeout = 0
      decoration {
        active_opacity = 1
        inactive_opacity = 1
        fullscreen_opacity = 1.0
        rounding = 3
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        shadow_ignore_window = true
      # col.shadow =
      # col.shadow_inactive
      # shadow_offset
        dim_inactive = false
      # dim_strength = #0.0 ~ 1.0
      }
      animations {
        enabled=1
        bezier = md3_standard, 0.2, 0, 0, 1
        bezier = md3_decel, 0.05, 0.7, 0.1, 1
        bezier = md3_accel, 0.3, 0, 0.8, 0.15
        bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = crazyshot, 0.1, 1.5, 0.76, 0.92
        bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
        bezier = fluent_decel, 0.1, 1, 0, 1
        # Animation configs
        animation = windows, 1, 2, md3_decel, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 2, default
        animation = workspaces, 1, 3, md3_decel
        animation = specialWorkspace, 1, 3, md3_decel, slidevert
      }
      plugin {
        hyprbars {
          bar_color = rgb(${darker})
          bar_height = 45
          bar_text_font = "Rubik"
          bar_text_align = left
          bar_part_of_window = true
          bar_button_padding = 14
          bar_padding = 14
          bar_precedence_over_border = true
          hyprbars-button = rgb(${color1}), 16, , hyprctl dispatch killactive
          hyprbars-button = rgb(${color2}), 16, , hyprctl dispatch fullscreen 1
        }
      }
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 4
        workspace_swipe_distance = 250
        workspace_swipe_invert = true
        workspace_swipe_min_speed_to_force = 15
        workspace_swipe_cancel_ratio = 0.5
        workspace_swipe_create_new = true
      }
      misc {
        disable_autoreload = true
        disable_hyprland_logo = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        enable_swallow = true
        swallow_regex =
        focus_on_activate = true
      }
    '';
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

  programs.foot = {
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
