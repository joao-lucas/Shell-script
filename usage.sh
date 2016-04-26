#!/bin/bash
CPU=$(cat /proc/cpuinfo | grep "model name" | uniq | sed 's/.*://')
RAM=$(free -h | sed '1d' | sed '2d' | cut -c 16-21)
RAIZ=$(df -h / | tail -n 1 | cut -d ' ' -f 11)
echo "CPU ...................................: " $CPU
echo "Memória RAM ...........................: " $RAM
echo "Uso de Disco ( / ) ....................: " $RAIZ
