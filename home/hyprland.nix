{
  config,
  lib,
  pkgs,
  hyprland,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    systemdIntegration = true;
    systemd.enable = true;
  };
}
