{inputs}: let
  replaceFrom = "if [ -d \"plugins/remote-dev-server\" ]; then";
  replaceTo = "if false; then";
  additionalCommand = ''
    if [ -d "plugins/remote-dev-server" ]; then
      patch -F3 -p1 < ${./patches/jetbrains-remote-dev.patch}
    fi
  '';
in {
  modifications = final: prev: {
    jetbrains.idea-ultimate = prev.jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
      postPatch = (builtins.replaceStrings [replaceFrom] [replaceTo] oldAttrs.postPatch) + additionalCommand;
    });
  };
}
