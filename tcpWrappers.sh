#!/bin/bash
#
# Script de TCP Wrappers para segurança do inetd(super daemon).
# O TCP Wrappers existe para configurar filtros de acesso de entrada de pacotes que usam o protocolo TCP e fazer com que essa
#configuração possa ser mais simples possivel, a configuração do daemon tcpd é feita atraves dos arquivos hosts.allow e hosts.deny.
# Seu uso pode diminuir a probabilidade de um ataque a algum serviço privilegiado limitando o acesso somente para máquinas clientes. 
#
# Pacotes requeridos: inetd
#
# Autor: João Lucas <joaolucas@linuxmail.org>
# Github: https://github.com/joao-lucas
# Data: 20160601
#

if [ ! -e /etc/hosts.allow ]
then
	touch /etc/hosts.allow
	echo "#Sintaxe: <serviço>: <hosts>" >> /etc/hosts.allow
	# O serviço sshd sera liberado para os hosts 192.168.1.20 e 192.168.1.21
	echo "sshd: 192.168.1.20, 192.168.1.21" >> /etc/hosts.allow	
	echo "[ OK ] Hosts.allow configurado com sucesso!"
	sleep 2
else
	#cp /etc/hosts.allow /etc/hosts.allow.bkp
	echo "#Sintaxe: <serviço>: <hosts>" >> /etc/hosts.allow
	#Exemplo: O serviço sshd sera liberado para os hosts 192.168.1.20 e 192.168.1.21
	echo "sshd: 192.168.1.20, 192.168.1.21" >> /etc/hosts.allow	
	echo "[ OK ] Hosts.allow configurado com sucesso!"
	sleep 2
fi

# hosts.deny - esse é o arquivo de configuração de negação de acesso de entrada
#de pacotes dos serviços especificados.
if [ ! -e /etc/hosts.deny ]
then
        echo "~ Criando /etc/hosts.deny"
        touch /etc/hosts.deny	
	echo "#Sintaxe: <serviço>: <hosts>" >> /etc/hosts.deny
	# Somente as conexões definidas pelas regras de hosts.allow serão aceitas. 
	echo "ALL:ALL" >> /etc/hosts.deny
	echo "[ OK ] Hosts.deny configurado com sucesso!"
	sleep 2
else
	echo "O arquivo /etc/hosts.deny já existe, criando um backup do arquivo original e colocando novas entradas"
        cp /etc/hosts.deny /etc/hosts.deny.bkp
	echo "#Sintaxe: <serviço>: <hosts>" >> /etc/hosts.deny
	# Somente as conexões definidas pelas regras de hosts.allow serão aceitas.
	echo "ALL:ALL" >> /etc/hosts.deny
	echo "[ OK ] Hosts.deny configurado com sucesso!"
	
fi
