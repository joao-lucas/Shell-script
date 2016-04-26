#!/bin/bash
## Programa para testar a existencia de /etc/nologin
file=/etc/nologin
if test -f /etc/nologin
then
        echo "Apenas o root podera fazer o login"
else if test -d /etc/nologin
then
        echo "$file é um diretorio"
else
        echo "Login liberado para todos os usuarios"
fi
fi
