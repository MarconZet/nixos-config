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
    discord
    arduino
    piper
    winbox
  ];

  imports = [
    (import ./home.nix {inherit pkgs;})
  ];
}
