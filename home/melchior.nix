{
  inputs,
  config,
  pkgs,
  ...
}: let
in {
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.gateway
    vscode
    arduino
    winbox
    piper
    discord
    teamspeak6-client
    blender
    via
    prismlauncher
    gparted
    deluge
    wineWowPackages.waylandFull
    bottles
    slack
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
