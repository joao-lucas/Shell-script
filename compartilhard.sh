#!/bin/bash
# Script para proteger o servidor de ataques provenientes da Internet.
# Data: 08/08/2016
# Autor: Joao Lucas <joao-lucas@linuxmail.org>
# Github: joao-lucas
#

# Interface da Internet
if_internet="eth1"

# Interface da rede local
if_local="eth0"

iniciar(){
	modprobe iptable_nat
	# Ativar ip forward para permitir roteamento de pacotes entre as interfaces de rede
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A POSTROUTING -o $if_internet -j MASQUERADE
	# não responder pings
	iptables -A INPUT -p icmp --icmp-type echo-request -j DROP	
	# protejer contra ataques IP Spoofing e contra pacotes invalidos, que geralmente são usados em ataques DoSe ataques de buffer overflow
	echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter
	iptables -A INPUT -m state --state INVALID -j DROP
	# Autorizar pacotes provenientes da interface de loopback, juntamente com pacotes provenientes da rede local
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -i $if_local -j ACCEPT
	# abrir a porta 22 para usar SSH para conexões externas
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT
	# bloqueia tentativas de conexão vindas da INternet
	iptables -A INPUT -p tcp --syn -j DROP
}

parar(){
	iptables -F
	iptables -t nat -F
}

case $1 in
	start) iniciar ;;
	stop) parar ;;
	restart) parar ; iniciar ;;
	*) echo "USO: $0 start|stop|restart"
esac
