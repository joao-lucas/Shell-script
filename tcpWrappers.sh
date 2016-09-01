#!/bin/bash
#
# Script de TCP Wrappers para segurança do inetd(super daemon).
#O TCP Wrappers existe para configurar filtros de acesso de entrada de pacotes que usam o protocolo TCP. A configuração do daemon tcpd é feita atraves dos arquivos hosts.allow e hosts.deny.
# Seu uso pode diminuir a probabilidade de um ataque a algum serviço privilegiado limitando o acesso somente para máquinas clientes. 
#
# Pacotes requeridos: inetd, tcpd
#
# Referencias: Guia FOCA Linux Avan�ado, Certifica��o Linux.
# Autor: João Lucas <joaolucas@linuxmail.org>
# Github: https://github.com/joao-lucas
# Data: 2016-06-01
# 

# O arquivo /etc/hosts.allow � um arquivo � configura��o do programa /usr/sbin/tcpd. o arquivo hosts.allow contem regras descrevendo que hosts tem permiss�o de acessar um servi�o em sua maquina.
# O formato do arquivo � muito simples:
# > /etc/hosts.allow
# > lista de servi�os: lista de hosts : comando

# Lista de servi�os: � uma lista de nomes de servi�os separados por virgula que esta regra se aplica. Exemplos de nomes de servi�os s�o: ftpd, telnet e fingerd
# Lista de hosts: � uma lista de nomes de hosts separados por virgula
# Comando: � um parametro opcional.

## Exemplos /etc/hosts.allow
## Permite que qualquer um envie e-mails
#in.smtpd: ALL 
## Permite telnet e ftp somente para hosts locais e souz4.org.br
#in.telnetd,in.ftp: LOCAL, souz4.org.br
## Permitir finger para qualquer um mas manter um registro de quem �
#in.fingerd: ALL: (finger @%h | mail -s "finger from %h" root)

## Exemplos /etc/hosts.deny
## Bloqueia o acesso de computadores com endere�os suspeitos
#ALL: PARANOID
## Bloqueia todos os computadores
#ALL: ALL
## Tendo um padr�o ALL: ALL no arquivo /etc/hosts.deny e ent�o ativando especificamente os servi�os e permitindo computadores que voc� deseja no arquivo /etc/hosts.allow � a configura��o mais segura.

# Qualquer modifica��o no arquivo /etc/hosts.allow entrar� em a��o ap�s reniciar o daemon inetd. Isto pode ser feito com o comando kill -HUP [pid do inetd], o pid do inetd pode ser obtido com o comando ps ax | grep inetd

if [ ! -e /etc/hosts.allow ]
then
	touch /etc/hosts.allow
	echo "#Sintaxe: <serviço>: <hosts> : comando" >> /etc/hosts.allow
	# O serviço sshd sera liberado para os hosts 192.168.1.20 e 192.168.1.21
	echo "in.sshd: 192.168.1.20, 192.168.1.21" >> /etc/hosts.allow	
	echo "[ OK ] Hosts.allow configurado com sucesso!"
	sleep 2
else
	#cp /etc/hosts.allow /etc/hosts.allow.bkp
	echo "#Sintaxe: <serviço>: <hosts> : comando" >> /etc/hosts.allow
	#Exemplo: O serviço sshd sera liberado para os hosts 192.168.1.20 e 192.168.1.21
	echo "in.sshd: 192.168.1.20, 192.168.1.21" >> /etc/hosts.allow	
	echo "[ OK ] Hosts.allow configurado com sucesso!"
	sleep 2
fi

# hosts.deny - esse é o arquivo de configuração de negação de acesso de entrada
#de pacotes dos serviços especificados.
if [ ! -e /etc/hosts.deny ]
then
        echo "~ Criando /etc/hosts.deny"
        touch /etc/hosts.deny	
	echo "#Sintaxe: <serviço>: <hosts> : comando" >> /etc/hosts.deny
	# Somente as conexões definidas pelas regras de hosts.allow serão aceitas. 
	echo "ALL:ALL" >> /etc/hosts.deny
	echo "[ OK ] Hosts.deny configurado com sucesso!"
	sleep 2
else
	echo "O arquivo /etc/hosts.deny já existe, criando um backup do arquivo original e colocando novas entradas"
        cp /etc/hosts.deny /etc/hosts.deny.bkp
	echo "#Sintaxe: <serviço>: <hosts> : comando" >> /etc/hosts.deny
	# Somente as conexões definidas pelas regras de hosts.allow serão aceitas.
	echo "ALL:ALL" >> /etc/hosts.deny
	echo "[ OK ] Hosts.deny configurado com sucesso!"
	
fi
