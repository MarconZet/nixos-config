#!/usr/bin/env bash

set -e
pushd ~/nixos/

if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

git --no-pager diff -U0 '*.nix'

echo "NixOS Rebuilding..."

sudo nixos-rebuild switch --flake ~/nixos#melchior

current=$(nixos-rebuild list-generations | grep current)

git commit -am "$current"
git push
popd
