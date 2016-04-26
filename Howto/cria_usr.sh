#!/bin/bash
## Programa para criação de usuarios
clear
echo "Digite o login do usuario que você deseja criar: "
#read usr
useradd -m -d /home/$1 -s /bin/bash $1
echo "Definir senha para $1: "
passwd $1
