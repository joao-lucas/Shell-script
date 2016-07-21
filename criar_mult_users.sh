#!/bin/bash


# Declaração das variáveis #

USERADD=/usr/sbin/useradd
GROUPADD=/usr/sbin/groupadd
GPASSWD=/usr/bin/gpasswd
CHAGE=/usr/bin/chage

#--------------------------#
# Criptograr a senha dos usuários
PASSWORD="oc@2015"
PASS=$(perl -e 'print crypt($ARGV[0], "PASSWORD")' $PASSWORD)
#------------------------------------------------------------#

#Criação dos grupos aos quais os mesmos serão inseridos

$GROUPADD grupoA
$GROUPADD grupoB

#O comando for criará um loop para a criação do operador 1 ao 50 e o segundo loop
#do operador 51 ao 100

for((i=1; i <= 50; i++))
do
	#O comando useradd é usado para criar uma nova conta no sistema
	$USERADD -m -d /home/operador$i -s /bin/bash -p $PASS operador$i

	#O comando abaixo vai fazer com que a conta seja bloqueada no dia 
	#26/02/2015. O formato sempre deve estar AAAA/MM/DD

	$CHAGE -E 2015/02/26 operador$i

	#Após a criação da conta de cada usuário, os mesmos serão associados as seus
	#respectivos grupos

	$GPASSWD -a operador$i grupoA
done

for((i=51; i <= 100; i++))
do
	$USERADD -m -d /home/operador$i -s /bin/bash operador$i
	$CHAGE -E 2015/02/26 operador$i
	$GPASSWD -a operador$i grupoB
done
