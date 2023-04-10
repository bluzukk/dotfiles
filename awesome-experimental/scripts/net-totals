#!/bin/bash
# A Linux Shell script to collect total download (rx_bytes)
ifaces="$(ls -1 --color=never /sys/class/net)"

total=0
for interface in $ifaces; do
    rx_dev="$(cat /sys/class/net/$interface/statistics/rx_bytes)"
    total="$(expr $total + $rx_dev)"
done

total="$(expr $total / 1024 / 1024)"
echo $total
