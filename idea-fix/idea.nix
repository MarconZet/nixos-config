{
  pkgs,
  lib,
  ...
}: let
  replaceFrom = "if [ -d \"plugins/remote-dev-server\" ]; then";
  replaceTo = "if false; then";
  additionalCommand = ''
    if [ -d "plugins/remote-dev-server" ]; then
      patch -F3 -p1 < ${./jetbrains-remote-dev.patch}
    fi
  '';
in {
  environment.systemPackages = [
    (pkgs.jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
      postPatch = (builtins.replaceStrings [replaceFrom] [replaceTo] oldAttrs.postPatch) + additionalCommand;
    }))
  ];
}
