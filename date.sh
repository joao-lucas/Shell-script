#!/bin/bash
horas=$(date | cut -d " " -f 4 | cut -d : -f 1)
minutos=$(date | cut -d " " -f 4 | cut -d : -f 2)
segundos=$(date | cut -d " " -f 4 | cut -d : -f 3) 

#echo "$horas"
if (( "$horas" >= "06" )) && (( "$horas" <= "12" ))
then
        echo "Bom dia!"
elif (( "$horas" > "12" )) && (( "$horas" < "18" ))
then
        echo "Boa tarde!"
else
        echo "Boa noite!"
fi
