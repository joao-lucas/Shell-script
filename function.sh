#!/bin/bash

# Verifica se o primeiro argumento da função é vazio
function vazio() {
        if [ -z "$1" ] "shell";
        then
                # retorna 0 se o primeiro argumento é vazio
                return 0
        fi
        #retorna 1 caso contrario
        return 1
}
#testa se o retorno é 0 
if vazio
then
                echo "Nao passou argumentos"
else
        echo "passou o argumento"
fi

#funcao para somar dois numeros

function soma {

        s=$(( $1 + $2 )) # realiza a soma
        echo "$1 + $2 = $s" #exibe a soma
}

soma 10 20
