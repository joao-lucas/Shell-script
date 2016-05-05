#!/bin/bash

echo "Digite um ano: "
read ano
for MES in $(seq -w 1 12)
do
        echo -n "Ultimo dia do mês $MES/$ano = "
        echo $(cal $MES $ano) | awk '{print $NF}'
done
