#!/bin/bash
#Analise de nota nas provas da LPI
clear
read -p "Digite sua nota: " nota
if [ $nota -ge 500 ] && test $nota -le 799
then
        echo "Você foi aprovado"
else
        echo "Voce foi reprovado"
fi
