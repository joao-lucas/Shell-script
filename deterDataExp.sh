#!/bin/bash

# Script para determinar data de expiração para contas de usuários
# Data: 21/07/2016
# Autor: Joao Lucas <joaolucas@linuxmail.org>

read -p "> Informe usuário: " user
cat /etc/passwd | cut -d: -f1 | grep -qw $user 2> /dev/null 
if [ $? -eq 0 ]
then
        read -p "> Tempo Maximo de validade da conta(em dias): " max_dias
        read -p "> Tempo que o usuário começará a ser avisado antes da conta expirar: " aviso_dias
        read -p "> Tempo antes da conta ser desativada: " inativo
        sudo chage -M $max_dias -W $aviso_dias -I $inativo $user
else
        echo "[ FALHA ] O usuário não existe"
fi
