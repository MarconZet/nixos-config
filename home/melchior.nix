{
  inputs,
  config,
  pkgs,
  ...
}: let
in {
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    jetbrains.rust-rover
    jetbrains.idea-community
    jetbrains.pycharm-community
    arduino
    winbox
    piper
    webcord
    discord
    teamspeak3
    blender
    via
    prismlauncher
    gparted
    deluge
    wineWowPackages.waylandFull
    bottles
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
