#!/bin/bash

# Script para gerenciar contas de usuários
#  
# The MIT License (MIT)
# Copyright (c) 2016 João Lucas
#
# Data: 2017-01-30-v0.1
# Autor: João Lucas <joaolucas@linuxmail.org>
#

DATA_HOJE=$(date +%d/%m/%Y)
WIDTH=400
HEIGHT=200
TITLE_PADRAO="SNOW USER MANAGER"

menu_principal(){
	yad --title="$TITLE_PADRAO" \
	--width=$WIDTH \
	--height=$HEIGHT \
	--columns=2 \
	--center \
	--text="				\
	Bem vindo ao Snow User Manager" \
	--text-align=center \
	--image-on-top \
	--image /home/joao/akita.jpg \
	--button gtk-add:10 \
	--button "Determinar data de expiração":20 \
	--button "Visualizar Usuarios":30 \
	--button gtk-delete:40 \
	--button gtk-close:90

	case $? in
	10) cadastrar_user ;;
	20) determ_expiracao ;;
	30) exibir_users ;;
	40) delete_user ;;
	90) exit 0 ;;
	*) exit 1 ;;
	esac
}

cadastrar_user(){
	CADASTRAR_USER=$( \
		yad --form \
		--title="$TITLE_PADRAO" \
		--width=$WIDTH \
		--height=$HEIGHT \
		--field="Cadastrando em":RO "$DATA_HOJE" \
		--field="Nome completo:" "" \
		--field="Nome de usuario:" "" \
		--field="Shell" "" \
		--field="Senha":H \
		--button gtk-ok:10 \
		--button gtk-cancel:20 \
		--center
		);

	DATA=$(echo "$CADASTRAR_USER" | cut -d '|' -f 1)
	NOME=$(echo "$CADASTRAR_USER" | cut -d '|' -f 2)
	USER=$(echo "$CADASTRAR_USER" | cut -d '|' -f 3)
	SHELL=$(echo "$CADASTRAR_USER" | cut -d '|' -f 4)	
	SENHA=$(echo "$CADASTRAR_USER" | cut -d '|' -f 5) 

	useradd -m -c "$NOME" -s "$SHELL" -p `echo $SENHA | mkpasswd -s -H md5` $USER
}

determ_expiracao(){
	
	DATA_EXP=$(yad --form \
	--title="$TITLE_PADRAO" \
	--center \
	--text="O tempo deve ser passado em Dias" \
	--field="Informe o nome do usuario: " "" \
	--field="Tempo maximo de validade da conta:" "" \
	--field="Tempo que ousuario começara a ser avisado antes da conta expirar:" "" \
	--field="Tempo antes da conta ser desativada:" "" \	
	--button gtk-ok \
	--button gtk-cancel 
	);
 
	USER=$(echo "$DATA_EXP" | cut -d '|' -f 1)
	TEMP_MAX=$(echo "$DATA_EXP" | cut -d '|' -f 2)
	DIAS_AVISO=$(echo "$DATA_EXP" | cut -d '|' -f 3)
	INATIVO=$(echo "$DATA_EXP" | cut -d '|' -f 4)
	
	cat /etc/passwd | cut -d ':' -f 1 | grep -qw $USER 2> /dev/null
	if [ "$?" -eq "0" ]
	then
		chage -M $TEMP_MAX -W $DIAS_AVISO -I $INATIVO $USER &> /dev/null
		yad --title="$TITLE_PADRAO" \
		--text="Data de expiração atualizada com sucesso!" \
		--button gtk-ok

	else
		yad --title="$TITLE_PADRAO" \
		--text="O usuario informado não existe!" \
		--button gtk-ok \
		--center \
		width=$WIDTH \
		height=$HEIGHT \
		--image error			
	fi
}

delete_user(){
	USER=$(yad --title="teste" \
	--text="Informe usuario" --entry --center
	);
	
	cat /etc/passwd | cut -d ':' -f 1 | grep -qw $USER 2> /dev/null
	if [ "$?" -eq "0" ]
	then
		userdel -r $USER	
		yad --title="$TITLE_PADRAO" \
		--text="Usuario $USER apagado com sucesso!" \
		--center \
		--button gtk-ok

	else
		yad --title="$TITLE_PADRAO" \
		--text="O usuario informado $USER não existe!" \
		--button gtk-ok \
		--center \
		width=$WIDTH \
		height=$HEIGHT \
		--image error			
	fi	
}

exibir_users(){
	cat /etc/passwd | tr ':' '\n' | yad  --title "Lista de usuarios" \
	--list \
	--title="$TITLE_PADRAO" \
	--column="Nome" \
	--column="Senha" \
	--column="UID" \
	--column="GID" \
	--column="Comentarios" \
	--column="diretorio" \
	--column="Shell" \
	--image terminal \
	--image-om-top \
	--button gtk-ok:10 \
	--center \
	---width=800 \
	--height=400 		
}
 
while true
do
	if [ `id -u` -eq "0" ] 
	then
		menu_principal
	else
		yad --title="$TITLE_PADRAO" \
		--text="Execute o script como root!" \
		--image warning --image-on-top \
		--timeout=5 --timeout-indicador=button \
		--center
		exit 1
		
	fi
done
