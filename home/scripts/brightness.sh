#!/usr/bin/env bash
set -euo pipefail

action=$1
file="$XDG_RUNTIME_DIR/ddc-token.txt"
file_press="$XDG_RUNTIME_DIR/ddc-press.txt"

sign=""

if [[ "$action" = "up" ]]; then
  sign="1"
elif [[ "$action" = "down" ]]; then
  sign="-1"
else
  echo "usage: $0 {up|down}"
  exit 2
fi

echo $sign >>$file_press

my_rand=$RANDOM
echo "$my_rand" >"$file"

sleep "0.2"

n_rand=$(cat $file)
if [[ $my_rand = $n_rand ]]; then
  sum=$(awk '{s+=$1} END {print s*10}' $file_press)
  rm $file_press

  if (( sum >= 0 )); then
    sign="+"
  else
    sign="-"
    sum=$(( -sum ))
  fi

  ddcutil setvcp --bus 3 10 "$sign" "$sum" --stats --skip-ddc-checks --noverify
  ddcutil setvcp --bus 5 10 "$sign" "$sum" --stats --skip-ddc-checks --noverify
else
  echo "Silenced mute"
fi
