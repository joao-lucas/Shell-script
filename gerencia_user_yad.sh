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
WIDTH=100
HEIGHT=100
TITLE_PADRAO="SNOW USER MANAGER"
AUTOR="João Lucas <joaolucas@linuxmail.org>"
CREDITOS="Gustavo Soares de Lima <gustavo@logicus.com.br>"
LICENSE="MIT"


menu_principal(){
	MENU=$(yad --title "$TITLE_PADRAO" \
	--list \
	--column "Icon:IMG" \
	--column "Opção" \
	--column "Descrição" \
	--maximized \
	gtk-add "Criar usuario" "Adicionar usuario ao sistema" \
	gtk-delete "Remover usuario" "Remover usuario do sistema" \
	users "Data expiração" "Determinar expiração da conta do usuario" \
	find "Ver usuarios" "Visualizar todos usuarios do sistema" \
	gtk-add "Criar grupo" "Criar grupo de usuarios" \
	gtk-add "Adicionar em grupo" "Adicionar usuario em grupo" \
	find "Ver grupos" "Visualizar todos grupos do sistema" \
	gtk-about "Sobre" "Sobre Snow User Manager" \
	--button gtk-ok \
	--button gtk-quit
	);
	
	ESCOLHA=$(echo $MENU | cut -d '|' -f2)
	
	case $ESCOLHA in
	"Criar usuario") criar_user ;;
	"Data expiração") determ_expiracao ;;
	"Ver usuarios") exibir_users ;;
	"Criar grupo") criar_grupo ;;
	"Adicionar em grupo") adicionar_user_grupo ;;
	"Remover usuario") delete_user ;;	
	"Ver grupos") exibir_grupos ;;
	"Sobre") about ;;
	*) exit 1 ;;
	esac
}

about(){
	yad --title="$TITLE_PADRAO" \
                --text="$TITLE_PADRAO \nAutor: $AUTOR \nCreditos: $CREDITOS \nLicense: $LICENSE" \
		--text-align=center \
                --image gtk-about \
                --image-on-top \
                --button gtk-close \
                --no-markup \
                --undecorated \
                --buttons-layout="center" \
		--center
}
criar_user(){
	CADASTRAR_USER=$( \
		yad --form \
		--title="$TITLE_PADRAO" \
		--width=$WIDTH \
		--height=$HEIGHT \
		--field="Cadastrando em":RO "$DATA_HOJE" \
		--field="Nome completo:" "" \
		--field="Nome de usuario:" "" \
		--field="Shell" "/bin/false" \
		--field="Senha":H "" \
		--field="Criar diretorio home":CHK TRUE \
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
	--field="Informe o nome do usuario:" "" \
	--field="Tempo maximo de validade da conta:":NUM "" \
	--field="Tempo que o usuario começara a ser avisado antes da conta expirar:"NUM "" \
	--field="Tempo antes da conta ser desativada:":NUM "" \	
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
	USR=$(yad --title="$TITLE_PADRAO" \
	 --form \
	 --field "Nome do usuario" "" \
	 #--field "Apagar diretorio home":CHK TRUE \
	 --center
	);
	
	USER=$(echo $USR | cut -d '|' -f 1)
	#DEL_HOME=$()	
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
	--maximized
}

criar_grupo(){
	
	GRP=$(yad --title="$TITLE_PADRAO" \
	--form \
	--field "Grupo" "" \
	--center
	);

	GRUPO=$(echo $GRP | cut -d '|' -f 1)
	groupadd $GRP 2> /dev/null
	if [ "$?" -eq "0" ]
	then	
		yad --title="$TITLE_PADRAO" \
		--text="Grupo $GRUPO criado com sucesso!" \
		--center \
		--button gtk-ok

	else
		yad --title="$TITLE_PADRAO" \
		--text="Ocorreram problemas em criar o grupo $GRUPO" \
		--button gtk-ok \
		--center \
		width=$WIDTH \
		height=$HEIGHT \
		--image error			
	fi
		
}

adicionar_user_grupo(){
	DADOS=$(yad --title="$TITLE_PADRAO" --form --field "Usuario" "" --field "Grupo" "" \
	--center
	); 
	
	USER=$(echo $DADOS | cut -d '|' -f 1)
	GRUPO=$(echo $DADOS | cut -d '|' -f 2)
	
	cat /etc/passwd | cut -d ':' -f 1 | grep -iw $USER && cat /etc/group | cut -d ':' -f 1 | grep -iw $GRUPO 2> /dev/null
	if [ "$?" -eq "0" ]
	then	
		usermod -G $GRUPO $USER
		yad --title="$TITLE_PADRAO" \
		--text="Usuario $USER adicionado no grupo $GRUPO com sucesso!" \
		--center \
		--button gtk-ok

	else
		yad --title="$TITLE_PADRAO" \
		--text="O usuario $USER ou o grupo $GRUPO não existe!" \
		--button gtk-ok \
		--center \
		width=$WIDTH \
		height=$HEIGHT \
		--image error			

	fi
		
}

exibir_grupos(){
	cat /etc/group | tr ':' '\n' | yad  --title "Lista de grupos" \
	--list \
	--column="Nome grupo" \
	--column="Senha" \
	--column="GID" \
	--column="Usuarios" \
	--image-om-top \
	--button gtk-ok:10 \
	--center \
	---width=400 \
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
