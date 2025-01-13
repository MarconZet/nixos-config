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
    teamspeak_client
    via
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
