#!/bin/bash

TITLE="Cracking WPA/WPA2"

function_menu(){	
	--list \
	MENU=$(yad --title="$TITLE" \
	--list \
	--column "Opção" \
	--column "Descrição" \
	"Monitor" "Ativar modo monitoramento" \
	"Escanear" "Scannear todas redes alcançadas" \
	"Escanear uma rede" "Scannear apenas uma rede especifica" \
	"Injetar" "" \
	"Deauth" \
	"Quebrar senha"	\
	--maximized \
	--button gtk-ok \
	--button gtk-quit
	 );

	MENU=$(echo "$MENU" | cut -d '|' -f 1)
	
	case $MENU in
	"Monitor") function_modo_monitoramento ;;
	"Escanear") function_escanear_todas_redes ;;
	"Escanear uma rede") function_escanear_uma_rede ;;
	*) echo
	esac
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
	--field "BSSID" "" \
	--field "ESSID" "" \
	--field "Channel" "" \	
	--field "Interface Mon" "eth0" \
	--field "Salvar na pasta":BTN "yad --file --directory" \ 
	--field "Nome no arquivo" "" \
	--button gtk-ok \
	--button gtk-cancel
	);
	
	BSSID=$(echo "$PARAMETROS" | cut -d '|' -f 1)
	ESSID=$(echo "$PARAMETROS" | cut -d '|' -f 2)
	CHANNEL=$(echo "$PARAMETROS" | cut -d '|' -f 3)
	INTERFACE_MON=$(echo "$PARAMETROS" | cut -d '|' -f 4)	
	DIR=$(echo "$PARAMETROS" | cut -d '|' -f 5)
	ARQ=$(echo "$PARAMETROS" | cut -d '|' -f 6)

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


#function_injetar_pacotes(){
#		
#}
 
while true
do
	if [ `id -u` -eq "0" ] 
	then
		function_menu
	else
		yad --title="$TITLE" \
		--text="Execute o script como root!" \
		--image warning --image-on-top \
		--timeout=5 --timeout-indicador=button \
		--center
		exit 1
		
	fi
done
