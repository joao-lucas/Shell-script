#!/bin/bash

# Função recursiva que calcula a potencia de um numero

# exemplo de chamada: script.sh 2 10
#onde 2 é a base e 10 é o expoente

function pot() {
D 
            return 1
    fi
        pot $1 $(( $2 - 1 ))
        return $(( $1 * $? ))    
        
}
# testa se passou dois parametros
if [ -z "$1" ] || [ -z "$2" ] 
then
      echo "Parametros insificientes"
      echo "Execute: script <base> <expoente> "
        echo "script.sh 2 10"


#pot $1 $2
#echo "$?"
