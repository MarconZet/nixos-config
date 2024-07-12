{
  pkgs,
  lib,
  ...
}: let
  # lutris-unwrapped is the "real" lutris. The lutris package that is
  # installed "wraps" the "real" lutris to make it actually work on
  # NixOS, but the source is compiled here.
  #
  # We use `overrideAttrs` to change the way the package is actually
  # built. In particular, this is because we want to override
  # something in the `stdenv.mkDerivation` call, this to be specific:
  #
  # https://github.com/NixOS/nixpkgs/blob/685d243d971c4f9655c981036b9c7bafdb728a0d/pkgs/applications/misc/lutris/default.nix#L131
  idea-unwrapped = pkgs.jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
    patches =
      oldAttrs.patches
      ++ [
        # Work around https://github.com/NixOS/nixpkgs/issues/173712
        #
        # TODO: Remove once updated upstream
        ./jetbrains-remote-dev.patch
      ];
  });
  # This is the lutris package we can actually install. It takes
  # lutris-unwrapped as an input, and then creates the usable package.
  #
  # We therefore need to override one of its arguments, rather than
  # its actual contents. We use `.override` for that. We override part
  # of this line:
  #
  # https://github.com/NixOS/nixpkgs/blob/685d243d971c4f9655c981036b9c7bafdb728a0d/pkgs/applications/misc/lutris/fhsenv.nix#L1
  idea-ultimate = pkgs.jetbrains.idea-ultimate.override {inherit idea-unwrapped;};
in {
  environment.systemPackages = [
    # This is the lutris we created above. If you use `with pkgs;`, this will still work, `with` is confusing,
    # but in a nutshell it doesn't override anything we ourselves declare in the outer "scope".
    idea-ultimate
  ];
}
