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
    jetbrains.idea-ultimate
    jetbrains.idea-community
    jetbrains.rust-rover
    discord
    arduino
    piper
    winbox
    ddcui
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
