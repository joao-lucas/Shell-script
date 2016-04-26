#!/bin/bash

# Implementação da sequencia de fibonacci
# Sequencia de fibonacci 1, 1. 2, 3. 5, 8, 13...
#       ou seja, ps dois primeiros termos são iguais a 1 e cada termo seguinte é a soma
#       dos dois termos imediatamente anteriores
#   Autor: Joao Lucas
# data: 2016/02/27
#

# testa se passou argumento

if [ "$1" == "" ]
then
        echo "Argumentos insuficientes!"
        echo "Exemplo: fibonacci.sh"
        exit 1
fi

if test $1 = 1 || test $1 = 2
then
        if test  $1 = 1
        then
                echo -e "1"
        fi
        if test $1 = 2
        then
                echo -e "1 1"
        fi
        exit 0
fi

# os dois primeiros termos da sequncia são iguais a 1
n1=1
n2=1

echo -n "1 1"
# loop começando de 2 e indo ate $1 (max)

for i in `seq 3 $1`
do 
        prox=$(($n1 + $n2))
        echo -n " $prox"
        aux=$n2
        n2=$prox
        n1=aux
done 

echo -e "\n"

