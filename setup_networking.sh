#!/bin/bash

echo "Configuring $1 as interface connected to robot"

sudo ip link set $1 up
sudo ip addr add 192.168.123.1/24 dev $1
sudo ip route add 192.168.123.0/24 dev $1

ping 192.168.123.110