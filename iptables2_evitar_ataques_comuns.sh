#!/bin/bash

# Script que evita ataques comuns ao servidor
# Salve o script dentro da pasta /etc/init.d, como em /etc/init.d/firewall
# de permissao de execução ao script: chmod +x /etc/init.d/firewall
# Uso: /etc/init.d/firewall start|stop|restart
# 
# Pra que o script seja executado durante o boot, crie um link para ele dentro da pasta /etc/rc5.d
# cd /etc/rc5.d
# ln -s ../init.d/firewall S29firewall
#
# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

function iniciar() {
# Abre para a faixa de endereços da rede local:
iptables -A INPUT -s 192.168.1.0/255.255.255.0 -j ACCEPT

# Faz a mesma coisa, só que especificando a interface de rede. Pode ser usada em substituição a regra anterior
# iptables -A INPUT -i eth0 -j ACCEPT

# Abre uma porta (inclusive para internet):
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Ignora pings:
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Protege contra IP spoofing:
echo 1 > /proc/sys/net/ipv4/conf/default/rp_filter

# Descarta pacotes malformados, protegendo contra ataques diversos:
iptables -A INPUT -m state --state INVALID -j DROP

# Abre para a interface de loopback. Esta regra é essencial para que o KDE e outros programas gráficos funcionen adequadamente:
iptables -A INPUT -i lo -j ACCEPT

# Impede a abertura de novas conexões, efetivamente bloqueando o acesso externo ao seu servidor, com excessão das portas e faixas de endereços especificados anteriormente:
iptables  -A INPUT -p tcp --syn -j DROP
echo "[ OK ] Regras de firewall ativadas!"
}

function parar() {
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
echo "[ OK ] Regras de firewall desativadas!"
}

case "$1" in
	"start") iniciar ;;
	"stop") parar ;;
	"restart") parar; iniciar ;;
	*) echo "Uso: $0 start|stop|restart"
esac
