#!/bin/bash

echo "Configuring $1 as interface connected to robot"

# Required to prevent nm interfering with manual configuration.
# Leaving this out can drop the connection and make the robot park up.
nmcli dev set $1 managed no

ip link set $1 up
ip addr add 192.168.123.129/25 dev $1

ping 192.168.123.238

# For some DUMB reason, the arms both try to claim 8880 and it's a mess. I love UDP.
iptables -t nat -A PREROUTING -s 192.168.1.238 -p tcp --dport 8880 -j REDIRECT --to-port 8889