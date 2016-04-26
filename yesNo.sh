#!/bin/bash
dialog --title 'Aviso' --yesno 'quer ver as horas?' 0 0;

if [ $? = 0 ]
then
        echo "agora sao: $(date)"
else
        echo "Ok, nao irei mostrar as horas"
fi
        
