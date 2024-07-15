{
  pkgs,
  lib,
  ...
}: let
  additionalCommands = ''

    echo 2137
  '';
in {
  environment.systemPackages = [
    (pkgs.jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
      postPatch = oldAttrs.postPatch + additionalCommands;
    }))
  ];
}
