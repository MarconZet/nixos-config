{
  inputs,
  config,
  pkgs,
  ...
}: let
  #  hyprland = inputs.hyprland;
  #  hyprland-plugins = inputs.hyprland-plugins;
in {
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
