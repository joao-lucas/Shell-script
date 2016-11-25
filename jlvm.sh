#!/bin/bash


# Esse script foi desenvolvido para automatizar algumas tarefas de LVM, como:
#	- Criar volumes fisicos 
#	- Criar grupo de volume
#	- Extender grupo de volume
#	- Diminuir grupo de volume
#	- Criar volumes logicos
#	- Extender volumes logicos
#	- Reduzir tamanho de volumes logicos
#	- Remover e mostrar detalhes de todos itens acima

#
# Distributed under the terms if the MIT License.
# See accompanying file LICENSE or copy at http://www.opensource.org/licenses/MIT_1_0.txt
#
# Autor: João Lucas <joaolucas@linuxmail.org>
#

# +----------------------------LVM-----------------------------------+
# |			        				     |
# |								     |
# |    +-------------+	         +-----------+      +--------------+ | 
# |    | /mnt/backup | 	         | /mnt/var  |      |  		   | |->Sistemas de Arquivos
# |    +-------------+ 	         +-----------+      |  Espaço não  | |
# |	       |		       |            |	alocado    | |
# | +---------------------+   +------------------+  |		   | |->Volumes logicos
# | | /dev/storage/backup |   |	/dev/storage/var |  |		   | |  
# | +---------------------+   +------------------+  +--------------+ |
# | 	       |		       |		    |	     |
# | +--------------------------------------------------------------+ |
# | |		            storage				   | |
# | +--------------------------------------------------------------+ |
# |	      |		    |	          |	        |	     |	
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
	echo "uso: $0 --menu|--help"
	exit 0
}


#
## VOLUME FISICO
# 1. Criar volume fisico (physical volume)
function pv_create() {
	read -p "Informe o volume fisico a ser CRIADO(ex.: /dev/sdc2):" volume_fisico
	pvcreate $volume_fisico
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Volume fisico criado!"
	else
		echo "[ FALHA ] Ocorreram erros! Verifique se o volume fisico esta correto."
		exit 0
	fi		
}

# 2. Remover volume fisico
function pv_remove() { 
	read -p "Informe o volume fisico a ser REMOVIDO: " volume_fisico
	pvremove $volume_fisico
	if [ $? -eq 0 ]
	then
		echo "[ OK ] Volume fisico removido!"
	else
		echo "[ FALHA ] Ocorreram erros! Verifique se o volume fisico esta correto."
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
	read -p "Nome do grupo de volumes: " gv_nome
	read -p "Informe os volumes fisicos(ex.: /dev/sda1 /dev/sda2 /dev/sdc1): " vg_volume_fisico
	vgcreate $gv_nome $vg_volume_fisico		
	if [ $? -eq 0 ]
	then
		echo " [ OK ] Grupo de volumes criado com sucesso!"
	else
		echo "[ FALHA ] Ocorreram erros na criação do grupo de volumes!"
		exit 1
	fi 
}

# 5. Remover grupo de volume
function vg_remove() {
	read -p "Nome do grupo de volume a ser REMOVIDO: " vg_nome
}

# 6. Mostrar detalhes do grupo de volume
function vg_display() {
	vgdisplay
}

# 7. Adicionar um novo volume fisico para o grupo de volume
function vg_extend() {
	read -p "Informe o grupo de volume: " grupo_volume 
	read -p "Informe o volume fisico a ser adicionado" volume_fisico
	vgextend $grupo_volume $volume_fisico
}

# 8. Remover volume fisico do grupo de volume
function vg_reduce() {
	read -p "Informe o volume fisico a ser REMOVIDO: " volume_fisico
	vgreduce $volume_fisico
}

# 9. Reconstruir o arquivo /etc/lvmtab
function vg_scan() { 
	vgscan
}


#
## VOLUME LOGICO
# 10. Criar volume logico
function lv_create() {

}

# 11. Remover volume logico
function lv_remove() {

}

# 12. Exibir detalhes do volume logico
function lv_display() {

}

# 13. Aumentar o tamanho do volume logico
function lv_extend() {

}

# 14. Diminuir o tamanho do volume logico
function lv_reduce() {

}


function menu() {
echo "1. [PV] Criar volume fisico"
echo "2. [PV] Remover volume fisico"
echo "3. [PV] Mostrar detalhes dos volumes fisicos"
echo "4. [VG] Criar grupo de volume"
echo "5. [VG] Remover grupo de volume"
echo "6. [VG] Mostrar detables do grupo de volumes"
echo "7. [VG] Extender grupo de volume"	
echo "8. [VG] Remover volume fisico de um grupo de volume"
echo "9. [VG] Scannear grupo de volumes "
echo "10. [LV] Criar volume logico"
echo "11. [LV] Remover volume logico"
echo "12. [LV] Mostrar detalhes do volume logico"
echo "13. [LV] Aumentar volume logico"
echo "14. [LV] Diminuir volume logico"
echo "99. Sair"
read -p "Entre com a opção: " opcao

case $opcao in
	"1") pv_create ;; 
	"2") pv_remove ;;
	"3") pv_display ;;
	"4") vg_create ;;
	"5") vg_remove ;;
	"6") vg_display ;;
	"7") vg_extend ;;
	"8") vg_reduce ;;
	"9") vg_scan ;; 
	"10") lv_create ;; 
	"11") lv_remove ;;
	"12") lv_display ;;
	"13") lv_extend ;;
	"14") lv_reduce ;;

	"99") exit 0 ;;	
esac
}

while true
do
        #USER=$(id -u)
        if test `id -u` -eq 0
        then
        	menu
        else
        echo "Executar o script como root!"
        fi
done

