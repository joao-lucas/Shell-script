#!/bin/bash
# Algumas regras do iptables retiradas do Livro: Servidores Linux, guia prático - Carlos E. Morimoto

#
## Trabalhando com portas de entrada (sentido internet > rede local)
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

#
## Forwarding de portas
# Redireciona uma faixa de portas para um micro da rede local:
echo 1 > /proc/sys/net/ipv4/ip_forward
# Faz com que o servidor encaminhe todas as conexões que receber na interface e porta especificada para o micro da rede local:
iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 6881:6889 -j DNAT --to 192.168.1.10
# Faz com que os pacotes de respostas encidos por ele possam ser encaminhados de volta:
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1

# Redireciona uma única porta para um micro da rede local:
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 22 -j DNAT --to 192.168.1.10
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1

# Redirecionando um conjunto de portas:
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp -i eth1 -m multiport --dport 21,22,80 -j DNAT --to-dest 192.168.1.10
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1

# Redirecionar uma porta UDP
echo 1 > /proc/sys/net/ipv4/ip_forward 
iptables -t nat -A PREROUTING -p udp -i eth1 --dport 53 -j DNAT --to 192.168.1.10
iptables -t nat -A POSTROUTING -d 192.168.1.10 -j SNAT --to 192.168.1.1


#
## Bloqueando portas de saída (sentido rede local > internet)
# Bloqueando a porta para FORWARD, você impede o acesso  partir dos micros da rede local, que acessam através da conexão compartilhada pelo servidor.
# Bloqueando para OUTPUT, a porta é bloqueada no próprio micro onde o firewall está ativo.
# Você pode bloquear as duas situações, duplicando a regra:
iptables -A OUTPUT -p tcp --dport 1863 -j REJECT
iptables -A FORWARD -p tcp --dport 1863 -j REJECT

# Bloquear intervalos de portas:
iptables -A FORWARD -p tcp --dport 1025:65536 -j REJECT
# Como estamos criando regras para micros da rede local e não para possíveis invasores da internet, é aconselhável usar a regra REJECT ao invés de DROP. Caso contrário, os programas nos clientes sempre ficarão muito tempo parados ao tentar acessar portas bloqueadas.

# Bloquear um a um todos os programas indesejados acaba sendo tedioso, ao invés disso você pode experimentar uma solução mais redical: inverter a lófica da regra, bloqueando todas as portas de saída e abrindo apenas algumas portas permitidas.
# O Mínimo que você precisa abrir neste caso são as portas 80(HTTP) e 53(DNS). A partir daí, você pode abrir mais portas, como a 25(SMTP), 110(POP3), 443(HTTPS) e assim por diante.
# Exemplo:
iptables -A FORWARD -p udp -i eth0 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp -i eth0 -j LOG
iptables -A FORWARD -p tcp -i eth0 -j REJECT
