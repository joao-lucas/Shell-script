#!/bin/bash

chave=1

# primeiro forma
if test "$chave" -eq 0
then
        echo "Chave Ligada!"
else
        echo "Chave desligada!"
fi

# segunda forma
if test "$chave" -eq 1
then
        echo "chave ligada"
else
        echo "chave desligada"
fi
# outra forma de fazer um if sem comando test
if [ "$chave" = "1" ]
then
        echo "chave ligada"
else
        echo "chave desligada"
fi
