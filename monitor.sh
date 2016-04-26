#!/bin/bash

funcao() {

CPU=$(cat /proc/cpuinfo | grep -i "model name" | cut -c13-55 | uniq)
RAM=$(free -h | grep -i mem | cut -c14-21)
DISTRO=$(lsb_release -d | cut -c14-33)
KERNEL=$(uname -r)
ARQ=$(uname -i)
FREE=$(which free)

##### FIM #####

echo "__________________________"
echo
echo " MONITORAMENTO DO SISTEMA "
echo "__________________________"
echo

echo "Inicio: " $(date +%T-%d/%m/%Y)

echo
echo ">>> INFORMACOES DO SISTEMA <<<"
echo

echo "Sistema Operacional: " $DISTRO
echo "Kernel em Uso:  " $KERNEL
echo "Arquitetura:  " $ARQ
echo "Hostname: " $(hostname)
echo "Processador:  " $CPU
echo "Total de Memoria RAM: " $RAM

echo
echo ">>> STATUS DA CPU <<<"
echo

/usr/bin/iostat -c 60 3 | sed '1,2d'

echo
echo ">>> STATUS DA MEMORIA RAM <<< "
echo

$FREE -h -c 3 -s 60

echo
echo ">>> STATUS DO HD <<<"
echo

echo "Utilizacao/Carga do Disco Rigido: "
echo

/bin/df -hT

echo

/usr/bin/iostat -d 60 3 | sed '1,2d'

}

funcao | tee /var/log/sysrelatorio.log
