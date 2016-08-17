#!/bin/bash
# Algumas regras do iptables 

#  loopback é usada por diversos programas como programas graficos
iptables -A INPUT -i lo -j ACCEPT

# Bloquear conexões vindo da internet
iptables -A INPUT -p tcp --syn -j DROP

# Abre para uma faixa de endereços:
iptables -A INPUT -s 192.168.1.0/255.255.255.0 -j ACCEPT	

# Aceita tudo na interface de rede local:
iptables -A INPUT -i eth0 -j ACCEPT

# Verifica tanto a interface quanto a faixa de endereços de origem:
iptables -A INPUT -s 192.168.1.0/255.255.255.0 -i eth0 ACCEPT

# Abre uma porta (inclusive para internet):
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Abre um conjunto de portas:
iptables -A INPUT -m multiport -p tcp --dport 22,80,443 -j ACCEPT

# Abre a porta para um IP especifico:
iptables -A INPUT -p tcp -s 200.231.14.17 --dport 22 -j ACCEPT

# Abre um intervalo de portas:
iptables -A INPUT -p tcp --dport 6881:6889 -j ACCEPT

# Verifica tanto o endereço IP quanto o MAC antes de aurotizar a conexão:
iptables -A INPUT -s 192.168.1.100 -m mac --mac-source 00:11:22:33:44:55 -j ACCEPT


