#!/bin/bash
lista=$(cat mac.txt)
for mac in $lista
do
        iptables -I FORWARD -m mac --mac-source $mac -j DROP
done
