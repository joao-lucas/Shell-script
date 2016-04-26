#!/bin/bash
# Programa que cria usuarios atraves de listas
lista=$(cat lista_usr.txt)
for usr in $lista
do
        useradd -m -d /home/$usr -s /bin/bash -c "$usr" -g users $usr
        echo "Usuario $usr foi criado com sucesso"
done
