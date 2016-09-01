#!/bin/bash
#
# Script de TCP Wrappers para seguranÃ§a do inetd(super daemon).
#O TCP Wrappers existe para configurar filtros de acesso de entrada de pacotes que usam o protocolo TCP. A configuraÃ§Ã£o do daemon tcpd Ã© feita atraves dos arquivos hosts.allow e hosts.deny.
# Seu uso pode diminuir a probabilidade de um ataque a algum serviÃ§o privilegiado limitando o acesso somente para mÃ¡quinas clientes. 
#
# Pacotes requeridos: inetd, tcpd
#
# Referencias: Guia FOCA Linux Avançado, Certificação Linux.
# Autor: JoÃ£o Lucas <joaolucas@linuxmail.org>
# Github: https://github.com/joao-lucas
# Data: 2016-06-01
# 

# O arquivo /etc/hosts.allow é um arquivo é configuração do programa /usr/sbin/tcpd. o arquivo hosts.allow contem regras descrevendo que hosts tem permissão de acessar um serviço em sua maquina.
# O formato do arquivo é muito simples:
# > /etc/hosts.allow
# > lista de serviços: lista de hosts : comando

# Lista de serviços: é uma lista de nomes de serviços separados por virgula que esta regra se aplica. Exemplos de nomes de serviços são: ftpd, telnet e fingerd
# Lista de hosts: é uma lista de nomes de hosts separados por virgula
# Comando: É um parametro opcional.

## Exemplos /etc/hosts.allow
## Permite que qualquer um envie e-mails
#in.smtpd: ALL 
## Permite telnet e ftp somente para hosts locais e souz4.org.br
#in.telnetd,in.ftp: LOCAL, souz4.org.br
## Permitir finger para qualquer um mas manter um registro de quem é
#in.fingerd: ALL: (finger @%h | mail -s "finger from %h" root)

## Exemplos /etc/hosts.deny
## Bloqueia o acesso de computadores com endereços suspeitos
#ALL: PARANOID
## Bloqueia todos os computadores
#ALL: ALL
## Tendo um padrão ALL: ALL no arquivo /etc/hosts.deny e então ativando especificamente os serviços e permitindo computadores que você deseja no arquivo /etc/hosts.allow é a configuração mais segura.

# Qualquer modificação no arquivo /etc/hosts.allow entrará em ação após reniciar o daemon inetd. Isto pode ser feito com o comando kill -HUP [pid do inetd], o pid do inetd pode ser obtido com o comando ps ax | grep inetd

if [ ! -e /etc/hosts.allow ]
then
	touch /etc/hosts.allow
	echo "#Sintaxe: <serviÃ§o>: <hosts> : comando" >> /etc/hosts.allow
	# O serviÃ§o sshd sera liberado para os hosts 192.168.1.20 e 192.168.1.21
	echo "in.sshd: 192.168.1.20, 192.168.1.21" >> /etc/hosts.allow	
	echo "[ OK ] Hosts.allow configurado com sucesso!"
	sleep 2
else
	#cp /etc/hosts.allow /etc/hosts.allow.bkp
	echo "#Sintaxe: <serviÃ§o>: <hosts> : comando" >> /etc/hosts.allow
	#Exemplo: O serviÃ§o sshd sera liberado para os hosts 192.168.1.20 e 192.168.1.21
	echo "in.sshd: 192.168.1.20, 192.168.1.21" >> /etc/hosts.allow	
	echo "[ OK ] Hosts.allow configurado com sucesso!"
	sleep 2
fi

# hosts.deny - esse Ã© o arquivo de configuraÃ§Ã£o de negaÃ§Ã£o de acesso de entrada
#de pacotes dos serviÃ§os especificados.
if [ ! -e /etc/hosts.deny ]
then
        echo "~ Criando /etc/hosts.deny"
        touch /etc/hosts.deny	
	echo "#Sintaxe: <serviÃ§o>: <hosts> : comando" >> /etc/hosts.deny
	# Somente as conexÃµes definidas pelas regras de hosts.allow serÃ£o aceitas. 
	echo "ALL:ALL" >> /etc/hosts.deny
	echo "[ OK ] Hosts.deny configurado com sucesso!"
	sleep 2
else
	echo "O arquivo /etc/hosts.deny jÃ¡ existe, criando um backup do arquivo original e colocando novas entradas"
        cp /etc/hosts.deny /etc/hosts.deny.bkp
	echo "#Sintaxe: <serviÃ§o>: <hosts> : comando" >> /etc/hosts.deny
	# Somente as conexÃµes definidas pelas regras de hosts.allow serÃ£o aceitas.
	echo "ALL:ALL" >> /etc/hosts.deny
	echo "[ OK ] Hosts.deny configurado com sucesso!"
	
fi
