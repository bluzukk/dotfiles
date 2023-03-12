#!/bin/bash
# A Linux Shell script to collect network information.

echo ""
echo "---------------------------------------"
ls -1 --color=never /sys/class/net |
  while IFS= read -r line
  do
    state="$(cat /sys/class/net/$line/operstate)"
    rx="$(cat /sys/class/net/$line/statistics/rx_bytes)"
    rx="$(expr $rx / 1024 / 1024)"
    if [ "$state" = "up" ]; then
      # echo "$line | $state =) |" | column -t
      printf "  %-10s %-7s =)  Down:$rx'mb\n" $line $state
    else
      printf "  %-10s %-7s =(  Down:$rx'mb\n" $line $state
    fi
  done
echo "---------------------------------------"
