#!/bin/bash
#  
# data : 2016/05/04
#
# Autor: Joao Lucas
#

PASSWD='forense'
#USER='joao_lucas'

echo "> Excluindo usuário joao_lucas"
userdel joao_lucas
if [ $? -eq 0 ]
then
	echo "[ OK ] Usuário joao_lucas excluido!"
	sleep 1
else
	echo "[ FALHA ] Ocorreu problemas em excluir usuário!"
	sleep 2
fi

useradd -d /home/joao_lucas/ -c "Joao Lucas" -s /usr/bin/zsh -g users -G dbus,network,audio,mpd,git,lxdm,video joao_lucas
if [ $? -eq 0 ]
then
	echo "[ OK ] Usuário adicionado com sucesso!"
else
	echo "[ FALHA ] Ocorreu problemas em adicionar o usuário!"
fi

echo "> Senha para o usuário"
sleep 1
passwd joao_lucas

