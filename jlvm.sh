#!/bin/bash

# Esse script foi desenvolvido para automatizar algumas tarefas de LVM(Logical Volume Manager), e tem como objetivo:
#	- Criar volume fisico
#	- Remover volume fisico 
#	- Criar grupo de volume
#	- Remover volume fisico de um grupo de volume
#	- Remover todo um grupo de volume
#	- Estender grupo de volume
#	- Criar volume logico
#	- Remover volume logico
#	- Estender volume logico
#	- Reduzir tamanho de volume logico
#	- Mostrar detalhes de todos itens acima
#

#
# The MIT License (MIT) 
# Copyright (c) 2016 João Lucas
#
# 	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
#	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Required packages: lvm2
# Date: 2016-11-25.v1
#
# Author: João Lucas <joaolucas@linuxmail.org>
#

#			      +-----+	
# +---------------------------| LVM |--------------------------------+
# |			      +-----+				     |
# |								     |
# |    +-------------+	         +-----------+      +--------------+ | 
# |    | /mnt/backup | 	         | /mnt/var  |      |  		   | |->Sistemas de arquivos
# |    +-------------+ 	         +-----------+      |  Espaço não  | |
# |	      |		   	       |            |	alocado    | |
# | +---------------------+   +------------------+  |		   | |->Volumes logicos
# | | /dev/storage/backup |   |	/dev/storage/var |  |		   | |  
# | +---------------------+   +------------------+  +--------------+ |
# | 	      |		       	       |		   |	     |
# | +---------------+ +--------------------------------------------+ |
# | | grupo volume1 | |        	    grupo volume2		   | |->Grupos de volumes
# | +---------------+ +--------------------------------------------+ |
# |	      |		    |	  	  |	        |	     |	
# |     +-----------+ +-----------+ +-----------+ +-----------+	     | 
# |     | /dev/sda1 | | /dev/sda2 | | /dev/sdb1 | | /dev/sdc1 |	     |->Volumes fisicos
# |     +-----------+ +-----------+ +-----------+ +-----------+      |
# +------------------------------------------------------------------+
#             |		    |		  |		|
# 	+-----------+ +-----------+ +-----------+ +-----------+		
# 	| /dev/sda1 | | /dev/sda2 | | /dev/sdb1	| | /dev/sdc1 |->Partições
# 	+-----------+ +-----------+ +-----------+ +-----------+
# 		 \	 /	 	  |		|
# 		+----------+ 	     +----------+ +----------+
# 		|----------| 	     |----------| |----------|
# 		| DISCO 1  | 	     |  DISCO 2 | | DISCO 3  |->Disco rigidos
#		| /dev/sda |	     | /dev/sdb | | /dev/sdc |
#		+----------+ 	     +----------+ +----------+
#


# Função para mostrar o modo de uso do script
function usage() {
	echo "uso: $0"
	exit 0
}

function separador() {
	echo "====================================================================================="
}

#
## VOLUME FISICO
# 1. Criar volume fisico (physical volume)
function pv_create() {
	separador
	pvscan
	separador	
	read -p "Informe o volume fisico a ser CRIADO(ex.: /dev/sdc2):" volume_fisico
		pvcreate $volume_fisico > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume fisico "$volume_fisico" criado com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros! Verifique se o volume fisico esta correto."
		exit 1
	fi		
}

# 2. Remover volume fisico
function pv_remove() { 
	separador
	pvscan
	separador	
	read -p "Informe o volume fisico a ser REMOVIDO: " volume_fisico
	pvremove $volume_fisico --force > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume fisico "$volume_fisico" foi REMOVIDO!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros! Verifique se o volume fisico "$volume_fisico" esta correto."
		exit 1
	fi	
}

# 3. Mostrar detalhes dos volumes fisicos
function pv_display() {
	pvdisplay
}


#
## GRUPO DE VOLUME 
# 4. Criar grupo de volume (volume group)
function vg_create() {
	separador
	vgscan
	separador
	
	read -p "Nome do grupo de volume: " grupo_volume
	read -p "Informe os volumes fisicos(ex.: /dev/sda1 /dev/sda2 /dev/sdc1): " volume_fisico
	vgcreate $grupo_volume $volume_fisico > /dev/null 2>> lvm-erros.txt	
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Grupo de volume "$grupo_volume" CRIADO com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros na CRIAÇÃO do grupo de volume "$grupo_volume"!"
		exit 1
	fi 
}

# 5. Remover grupo de volume
function vg_remove() {
	separador
	vgscan
	separador
	read -p "Nome do grupo de volume a ser REMOVIDO: " grupo_volume
	vgremove $grupo_volume > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Grupo de volume "$grupo_volume" REMOVIDO com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros na REMOÇÃO do grupo de volume "$grupo_volume"!"
		exit 1
	fi 
}

# 6. Mostrar detalhes do grupo de volume
function vg_display() {
	vgdisplay
}

# 7. Adicionar um novo volume fisico para o grupo de volume
function vg_extend() {
	separador
	vgscan
	separador
	read -p "Informe o grupo de volume: " grupo_volume 
	separador
	pvscan
	separador
	read -p "Informe o volume fisico a ser adicionado: " volume_fisico
	vgextend $grupo_volume $volume_fisico > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Novo volume fisico "$volume_fisico" ADICIONADO no grupo de volume "$grupo_volume" com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em ADICIONAR volume fisico "$volume_fisico" no grupo de volume "$grupo_volume"!"
		exit 1
	fi 
}

# 8. Remover volume fisico do grupo de volume
function vg_reduce() {
	separador
	pvscan
	separador
	read -p "Informe o volume fisico a ser REMOVIDO: " volume_fisico
	read -p "Grupo de volume que o volume fisico faz parte: " grupo_volume
	vgreduce $grupo_volume $volume_fisico > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume fisico "$volume_fisico" REMOVIDO do grupo de volume "$grupo_volume" com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em REMOVER o volume fisico "$volume_fisico" do grupo de volume "$grupo_volume"!"
		exit 1
	fi 
}

# 9. Reconstruir o arquivo /etc/lvmtab
function vg_scan() { 
	vgdisplay
}


#
## VOLUME LOGICO
# 10. Criar volume logico
function lv_create() {
	separador
	lvscan
	separador
	read -p "Nome do volume logico: " volume_logico
	read -p "Infome o grupo de volume: " grupo_volume
	read -p "Tamanho do grupo de volume(ex.: 512MB 100GB 2TB):" tamanho
	lvcreate -L $tamanho -n $volume_logico $grupo_volume > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume logico "$volume_logico" de "$tamanho" CRIADO com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros na CRIAÇÃO do volume logico "$volume_logico"!"
		exit 1
	fi 
}

# 11. Remover volume logico
function lv_remove() {
	separador
	lvscan
	separador
	echo "[ ATENÇÃO ] Antes de remover um volume lógico, é preciso desmontalo!"
	read -p "Informe o volume logico a ser REMOVIDO(/dev/grupo-volume/volume-logico): " volume_logico
	lvremove $volume_logico --force > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume logico "$volume_logico" REMOVIDO com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros na REMOÇÃO do volume logico "$volume_logico"!"
		exit 1
	fi 
}


# 12. Exibir detalhes do volume logico
function lv_display() {
	lvdisplay
}

# 13. Aumentar o tamanho do volume logico
function lv_extend() {
	separador
	lvscan
	separador
	echo "[ ATENÇÃO ] Verifique que o volume logico esta desmontado antes de prosseguir!"
	read -p "Informe o volume logico(ex.: /dev/grupo_volume1/volume1): " volume_logico
	read -p "Tamanho do volume logico depois do redimensionamento: " tamanho
	lvresize -L $tamanho $volume_logico > /dev/null 2>> lvm-erros.txt	
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume logico "$volume_logico" REDIMENSIONADO com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em REDIMENSIONAR o volume logico "$volume_logico"!"
		exit 1
	fi 	
	echo "Verificando se ocorreu algum erro..."
	e2fsck -f $volume_logico 2>> lvm-erros.txt
	echo "Atualizando a tabela de alocação de arquivos..."
	resize2fs $volume_logico > /dev/null 2>> lvm-erros.txt
	
}

# 14. Diminuir o tamanho do volume logico
function lv_reduce() {
# OBS. Quando você vai EXPANDIR um volume LVM, primeiro redimensiona o volume e depois atualiza as informações do sistema de arquivos.
# Quando você DIMINUIR o volume logico, primeiro atualiza a informação do sistema de arquivos, e depois reduz o tamanho do volume.
# Isso é para evitar a perda de dados
	separador
	lvscan
	separador
	echo "[ ATENÇÃO ] Verifique que o volume logico esta desmontado antes de prosseguir!"
        read -p "Informe o volume logico(ex.: /dev/grupo_volume1/volume1): " volume_logico
        read -p "Tamanho do volume logico depois da redução: " tamanho
	echo "Verificando se há erros no volume... "
	e2fsck -f $volume_logico 2>> lvm-erros.txt	
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Checagem no volume logico "$volume_logico"!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros na checagem do volume logico "volume_logico"!"
		exit 1
	fi 	
	resize2fs $volume_logico > /dev/null 2>> lvm-erros.txt
	lvresize -L $tamanho $volume_logico --force > /dev/null 2>> lvm-erros.txt
	if [ $? -eq 0 ]
	then
                echo -e "\n [\033[0;32m OK\033[0m ] Volume logico "$volume_logico" DIMINUIDO com sucesso!"
	else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em DIMINUIR o volume logico "$volume_logico"!"
		exit 1
	fi 	
}

function logo() {
	separador
	echo "
			     ██╗██╗    ██╗   ██╗███╗   ███╗
			     ██║██║    ██║   ██║████╗ ████║
			     ██║██║    ██║   ██║██╔████╔██║
			██   ██║██║    ╚██╗ ██╔╝██║╚██╔╝██║
			╚█████╔╝███████╗╚████╔╝ ██║ ╚═╝ ██║
			 ╚════╝ ╚══════╝ ╚═══╝  ╚═╝     ╚═╝	
			 Joao Logical Volume Manager v0.1"
	separador
}



function menu() {
	logo
	echo "1. Volume fisico " 
	echo "2. Grupo de volume"
	echo "3. Volume logico"
	echo "0. Sair"
	read -p "> " opt

case $opt in
	1) echo "1. Criar volume fisico"
	echo "2. Remover volume fisico"
	echo "3. Mostrar detalhes dos volumes fisicos"
	echo "0. Voltar"
	read -p "> " opt
	
	case $opt in
	"1") pv_create ;;
	"2") pv_remove ;;	
	"3") pv_display ;;
	"0") menu ;;
	"*") echo "\n [\033[0;31m FALHA\033[0m ]  Opção Invalida" ;;  
	esac
	;;

	2) echo "1. Criar grupo de volume"
	echo "2. Remover volume fisico de um grupo de volume"
	echo "3. Remover todo um grupo de volume"
	echo "4. Estender grupo de volume"
	echo "5. Mostrar detalhes dos grupos de volumes"
	echo "0. Voltar"
	read -p "> " opt
	
	case $opt in
	"1") vg_create ;;
	"2") vg_reduce ;;
	"3") vg_remove ;;
	"4") vg_extend ;;	
	"5") vg_display ;;
	"0") menu ;;
	"*") echo "\n [\033[0;31m FALHA\033[0m ]  Opção invalida!" ;;
	esac	 
	;;

	3) echo "1. Criar volume logico"
	echo "2. Remover volume logico"
	echo "3. Mostrar detalhes do volume logico"
	echo "4. Aumentar volume logico"
	echo "5. Diminuir volume logico"
	echo "0. Voltar"
	read -p "> " opt
	
	case $opt in
	"1") lv_create ;;
	"2") lv_remove ;;
	"3") lv_display ;;
	"4") lv_extend ;;
	"5") lv_reduce ;;
	"0") menu ;;	
	"*") echo "\n [\033[0;31m FALHA\033[0m ]  Opção invalida!";;
	esac
	;;
	
	
	0) exit 0 ;; 	

	*) echo "\n [\033[0;31m FALHA\033[0m ]  Opção invalida!" ;;
	
esac

}


#function menu() {
#	logo
#	echo
#	echo "1. [PV] Criar volume fisico"
#	echo "2. [PV] Remover volume fisico"
#	echo "3. [PV] Mostrar detalhes dos volumes fisicos"
#	echo "4. [VG] Criar grupo de volume"
#	echo "5. [VG] Remover grupo de volume"
#	echo "6. [VG] Mostrar detalhes do grupo de volumes"
#	echo "7. [VG] Estender grupo de volume"	
#	echo "8. [VG] Remover volume fisico de um grupo de volume"
#	echo "9. [VG] Scannear grupo de volumes "
#	echo "10. [LV] Criar volume logico"
#	echo "11. [LV] Remover volume logico"
#	echo "12. [LV] Mostrar detalhes do volume logico"
#	echo "13. [LV] Aumentar volume logico"
#	echo "14. [LV] Diminuir volume logico"
#	echo "99. Sair"
#	read -p "Entre com a opção: " opcao
#	echo
#
#case $opcao in
#	"1") pv_create ;; 
#	"2") pv_remove ;;
#	"3") pv_display ;;
#	"4") vg_create ;;
#	"5") vg_remove ;;
#	"6") vg_display ;;
#	"7") vg_extend ;;
#	"8") vg_reduce ;;
#	"9") vg_scan ;; 
#	"10") lv_create ;; 
#	"11") lv_remove ;;
#	"12") lv_display ;;
#	"13") lv_extend ;;
#	"14") lv_reduce ;;
#	
#	"99") exit 0 ;;	
#	*) usage ;;
#esac
#}


while true
do
        if test `id -u` -eq 0
        then
		if [ $# -ge 1 ]
		then
			usage
		else
			menu
		fi
        else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Executar o script como root!"
        	exit 1
	fi
done
