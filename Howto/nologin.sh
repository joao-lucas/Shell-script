#!/bin/bash
## Programa para verificar a existencia de /etc/nologin

while test -f /etc/nologin
do
        echo "Login liberado apenas para o root"
done
echo "Login Liberado para todos"


