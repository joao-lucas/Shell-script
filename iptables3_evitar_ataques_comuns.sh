#!/bin/bash
# Script escrito voltado para um servidor de rede local, configurado como gateway da rede.
# Este script de firewall inclui as regras para compartilhar a conexão e ativar o proxy transparente.
# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

iniciar() {
# Compartilha a conexão:
modprobe iptables_nat
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
echo "[ OK ] Compartilhamento ativado!"

# Proxy transparente:
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3128
echo "[ OK ] Proxy transparente ativado!"

# Permite conexões na interface de rede local e na porta 22:
iptables -A INPUT -i eth0 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Regras básicas de firewall:
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter
iptables -A INPUT -p tcp --syn -j DROP

# Bloqueia as portas UDP de 0 a 1023:
iptables -A INPUT -p udp --dport 0:1023 -j DROP
echo "[ OK ] Regras de firewall e compartilhamento ativos!"
}

parar() {
iptables -F
iptables -t nat -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
echo 0 > /proc/sys/net/ipv4/ip_forward
echo "[ OK ] Regras de firewall e compartilhamento desativados!"
}

case "$1" in
	"start") iniciar ;;
	"stop") parar ;;
	"restart") parar; iniciar ;;
	*) echo "Uso: $0 start|stop|restart"
esac
