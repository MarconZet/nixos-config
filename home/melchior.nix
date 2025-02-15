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
    ddcui
    piper
    webcord
    discord
    teamspeak_client
    via
    prismlauncher
    gparted
    deluge
    wineWowPackages.waylandFull
    lutris
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
