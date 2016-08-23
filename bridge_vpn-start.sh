#!/bin/bash
# Script para ativar o bridge no openvpn
# Requerimentos: bridge-utils, openvpn
# /etc/openvpn/bridge-start
# Data: 2016-08-23
# Autor: João Lucas <joaolucas@linuxmail.org>
#

br="br0"
tap="tap0"
eth="eth0"
eth_ip="192.168.1.101"
eth_gw="192.168.1.1"
eth_netmask="255.255.255.0"
eth_broadcast="192.168.1.255"

for i in $tap
do
        openvpn --mktun --dev $i
done

brctl addbr $br
brctl addif $br $eth

for i in $tap
do
        brctl addif $br $i
done

for i in $tap
do
        ifconfig $i 0.0.0.0 promisc up
done

ifconfig $eth 0.0.0.0 promisc up
ifconfig $br $eth_ip netmask $eth_netmask broadcast $eth_broadcast
route add default gw $eth_hw dev $br

iptables -A INPUT -i tap0 -j ACCEPT
iptables -A INPUT -i br0 -j ACCEPT
iptables -A FORWARD -i br0 -j ACCEPT
