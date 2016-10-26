#!/bin/bash

# Script de firewall para uso em um servidor web dedicado.
#
# Data: 2016/10/25
# retirado do livro: Servidores Linux, Guia Prático - Morimoto 
# por: João Lucas <joaolucas@linuxmail.org>
#

function iniciar(){
# Abre para a interface de loopback:
iptables -A INPUT -p tcp -i lo -j ACCEPT

# Bloqueia um determinado IP. Use para bloquear hosts específicos:
#iptables -A INPUT -p ALL -s 88:191:79:206 -j DROP

# Abre portas referentes aos serviços usados:
# SHH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# DNS
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT

# HTTP e HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Bloqueia conexões nas demais portas:
iptables -A INPUT -p tcp --syn -j DROP

# Garante que o firewall permitirá pacotes de conexões já iniciadas:
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j DROP

# Bloqueia as portas UDP de 0 a 1023 (com exceção das abertas acima):
iptables -A INPUT -p udp --dport 0:1023 -j DROP
}

function parar(){
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
}

case "$1" in
        "start") iniciar ;;
        "stop") parar ;;
        "restart") parar ; iniciar ;;
        *) echo "USO: $0 start|stop|restart"
esac
