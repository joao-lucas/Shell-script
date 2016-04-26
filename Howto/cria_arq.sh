#!/bin/bash
## Programa para criar arquivos em demanda
cont=0
read -p "Quantos arquivos você quer criar? " qtd
until test $qtd -eq $cont
do
        touch arq-$qtd
        qtd=$(( $qtd - 1 ))
done
