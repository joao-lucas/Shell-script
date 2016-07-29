#!/bin/bash

# Script para fazer download de musicas em mp3 do youtube
# Data: 28/07/2016
# Requerimentos: youtube-dl
# Autor: João Lucas <joaolucas@linuxmail.org>
#

data=`date +'%d-%m-%Y-%H-%M'`
arq=/tmp/$data.ytb-dl

if [ $# -eq 1 ]
then
        echo $arq
        youtube-dl --extract-audio --audio-format mp3 $1 2> /dev/null | tee $arq
        if [ $? -eq 0 ]
        then
                musica=`cat $arq | grep ffmpeg | cut -d: -f2 | cut -d- -f1,2`
                echo -e "\n [\033[0;32m OK\033[0m ] $musica baixado com sucesso!"
        else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram falhas em baixar o arquivo mp3!"
        fi
else
        echo "Uso: $0 <URL>"
        exit 1
fi

#rm -f /tmp/*.ytb-dl
exit 0
