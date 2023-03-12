#!/bin/bash
# A Linux Shell script to colle (rx_bytes)
host=1.1.1.1
host_ip=$(getent ahosts "$host" | awk '{print $1; exit}')
DEV=$(ip route get "$host_ip" | grep -Po '(?<=(dev ))(\S+)')

LINE=`grep $DEV /proc/net/dev | sed s/.*://`;
RECEIVED=`echo $LINE | awk '{print $1}'`
TRANSMITTED=`echo $LINE | awk '{print $9}'`
TOTAL=$(($RECEIVED+$TRANSMITTED))

SLP=1
sleep $SLP

LINE=`grep $DEV /proc/net/dev | sed s/.*://`;
RECEIVED=`echo $LINE | awk '{print $1}'`
TRANSMITTED=`echo $LINE | awk '{print $9}'`
SPEED=$((($RECEIVED+$TRANSMITTED-$TOTAL)/$SLP))

echo $SPEED
