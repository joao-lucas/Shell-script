#!/bin/bash
# programa para criar diretorios em demanda
cont=0
read -p "Quantos diretorios você quer criar? " qtd
while test $qtd -gt $cont
do
        cont=$(( $cont + 1))
        mkdir -v dir-$qtd
done
