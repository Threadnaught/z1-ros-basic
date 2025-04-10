#!/bin/bash

echo "Configuring $1 as interface connected to robot"

# Required to prevent nm interfering with manual configuration.
# Leaving this out can drop the connection and make the robot park up.
nmcli dev set $1 managed no

ip link set $1 up
ip addr add 192.168.123.1/24 dev $1
ip route add 192.168.123.0/24 dev $1

ping 192.168.123.110