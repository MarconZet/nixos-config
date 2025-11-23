#!/usr/bin/env bash
set -euo pipefail

action=$1
file="$XDG_RUNTIME_DIR/ptt.txt"

if [[ "$action" = "on" ]]; then
  my_rand=$RANDOM
  echo "$my_rand" >"$file"
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
  sleep 15
  n_rand=$(cat $file)
  if [[ $my_rand = $n_rand ]]; then
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
  else
    echo "Silenced mute"
  fi

elif [[ "$action" = "off" ]]; then
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
  rm "$file" 2>/dev/null
else
  echo "error"
fi