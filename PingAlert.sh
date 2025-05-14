#!/bin/bash
#set -x

# Array of IP addresses to ping
IP_ADDRESSES=("10.71.0.43" "10.71.0.44" "10.71.0.45")

#EMAIL="your.email@example.com"  # replace with your email address
SUBJECT="Ping Alert: Host is unreachable"

for HOST in "${IP_ADDRESSES[@]}"; do
    ping -c 5 $HOST > /dev/null

    if [ $? -ne 0 ]; then
        echo "Host $HOST is unreachable. "
        traceroute $HOST
#        echo "Ping failed for $HOST at $(date)" | mail -s "$SUBJECT" $EMAIL
    else
        echo "Host $HOST is reachable."
    fi
done

sleep 10
timestamp=$(date)
echo $timestamp

sleep 5

chown  vccuser.vccuser /home/vccuser/scripts/pingalert.out
