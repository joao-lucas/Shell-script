#!/bin/bash
## Calculadora IP
clear
read -p "Qual a sua rede? " rede
bits=$(( echo "$rede" | cut -d '/' -f 2 ))
#bits=` echo "$rede | cut -d '/' -f 2"`
bits=$(( 32-$bits ))

hosts=(( 2 ** $bits - 2 ))
# -2 porque dois endereços são reservados pra rede, e outro pro broadcast
# 192.168.1.0 e 192.168.1.255

echo "$hosts podem ser implementados nessa rede"
