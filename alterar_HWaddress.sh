#!/bin/bash
# Script básico para alterar o endereço MAC da placa de rede utilizando ifconfig 
# Autor: João Lucas <joaolucas@linuxmail.org>
#

if [ $# -eq 1 ]
then
	ifconfig eth0 down
	ifconfig eth0 hw ether "$1"
	if [ $? -eq 0 ]
	then
	 	ifconfig eth0 up
		echo "[ OK ] Endereço MAC alterado!"
		exit 0	
	else
		echo "[ FALHA ] Ocorreram erros em alterar o MAC!"
		exit 1
	fi
else
	echo "USO: $0 MAC_ADDRESS"
	echo "Exemplo: $0 00:11:22:33:44:55"
	exit 1
fi
