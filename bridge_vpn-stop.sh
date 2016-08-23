#!/bin/bash
# Respnsavel por desativar o bridge
# /etc/openvpn/bridge-stop

br="br0"
tap="top0"
ifconfig $br down
brctl delbr $br

for i in $trap
do
        openvpn --rmtun --dev $i
done
