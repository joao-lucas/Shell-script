#!/bin/bash
#
# Script para criar usuário, remover e adicionar usuário a um determinado grupo 
#
# Data: 2016/04/16 Versão 1.0
# Autor: João Lucas <joaolucas@linuxmail.org>
# Github: https://github.com/joao-lucas
#

function menu() {
clear 
echo "1. Cria usuário"
echo "2. Apaga usuário"
echo "3. Adiciona usuário em grupo"
echo "4. Sair" 
read -p "> " escolha

case $escolha in
	1) criaUser ;;
	2) apagaUser ;;
	3) addUserGroup ;;
	4) echo "Saindo... "; sleep 2; exit ;;
	*) echo "Opção invalida!";  sleep 2; menu ;;
esac
}

function criaUser() {
	read -p "> Nome de usuário: " user
	read -p "> Nome completo do usuário $user:" nome
	read -p "> Senha: " senha
	
	useradd -m -c "$nome" -s /bin/false -p `echo $senha | mkpasswd -s -H md5` $user
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Usuario $user criado com sucesso!"
		sleep 2
		menu
	else
		echo "[ FALHA ]  Ocorreu algum erro na criação de $user"
		sleep 2
		menu
	fi
}

function apagaUser() {
	read -p "> Qual usuário a ser removido? " user
	cat /etc/passwd | cut -d ':' -f 1 | grep -w $user
	if [ $? -eq 0 ]
	then
		userdel -r $user
		echo "[ OK ] Usuário $user removido com sucesso!"
		sleep 2
		menu

	else
		echo "[ FALHA ] Usuário $user não existe!"
		sleep 2
		menu
	fi  
}

function addUserGroup() {
	read -p "> Nome do usuário: " user
	read -p "> Nome do grupo: " grupo
	cat /etc/passwd | cut -d ':' -f 1 | grep -iw $user && cat /etc/group | cut -d ':' -f 1 | grep -iw $grupo
	if [ $? -eq 0 ]
	then
		usermod -G $grupo $user
		echo "[ OK ] Usuário $user adicionado ao grupo $grupo com sucesso!" 	
		sleep 2
		menu

	else
		echo "[ FALHA ] O usuário $user ou o grupo $grupo não existem!"
		sleep 2
		menu
	fi
}

while true
do
	menu
done
