{
  inputs,
  config,
  pkgs,
  ...
}: let
in {
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    teamspeak_client
    jetbrains.rust-rover
    jetbrains.idea-community
    jetbrains.pycharm-community
    discord
    arduino
    piper
    winbox
    ddcui
    webcord
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
