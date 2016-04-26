#!/bin/bash

# Script de Administração
# 
# Autor: Marcos Castro <mcastrosouza@live.com>
# Data: 29/02/2016
#

while true
do

	clear
	menu="\\t1) Ver processos ativos
\\t2) Mostra os files systems da máquina
\\t3) Mostra a quanto tempo a máquina está no ar
\\t4) Usuários ativos na máquina
\\t5) Versão do kernel
\\t6) Lista de usuários da máquina
\\t7) Sair do sistema"

	echo -e "$menu"

	echo "Escolha uma opção: "
	read op

	case $op in
		1) ps aux ;;
		2) df ;;
		3) tempo=`uptime | cut -d\  -f4,5`
			echo "A máquina está no ar a $tempo" ;;
		4) users | tr \  \\n ;;
		5) cat /proc/version | cut -d\  -f3 ;;
		6) cat /etc/passwd | cut -d: -f1 ;;
		7) exit ;;
		*) echo -e "Opção inválida!\n" ;;
	esac

	echo -e "\nPressione Enter para voltar ao menu...\n"
	read tecla

done
