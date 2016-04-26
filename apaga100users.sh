#!/bin/bash

# Declaração das variáveis #

USERDEL=/usr/sbin/userdel
GROUPDEL=/usr/sbin/groupdel
GPASSWD=/usr/bin/gpasswd

#--------------------------#

for((i=1; i <= 50; i++))
do
	#Retira os usuários dos seus respectivos grupos antes de excluir
	#a conta do sistema

	$GPASSWD -d operador$i grupoA

	#Apaga a conta bem como a pasta /home de cada operador
	$USERDEL -r usuario$i
done

for((i=51; i <= 100; i++))
do
	$GPASSWD -d operador$i grupoB
	$USERDEL -r usuario$i
done

#Exclusão dos grupos criados

$GROUPDEL grupoA
$GROUPDEL grupoB

