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
    jetbrains.goland
    vscode
    arduino
    winbox
    piper
    webcord
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
    claude-code
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
