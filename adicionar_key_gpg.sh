#!/bin/bash

# Sempre que adicionar novos repositorios no arquivo /etc/apt/sources.list, você começará a receber um erro de assinaturas GPG, este script foi criado para resolver este problema. 
# Data: 01/08/2016
# Autor: João Lucas <joaolucas@linuxmail.org>
#

if [ -z "$1" ]
then
        echo "Especifique os últimos 8 numeros da chave a ser adicionada"
        echo "USO: $0 <CHAVE_GPG>"
        exit 2
fi

gpg --keyserver pgpkeys.mit.edu --recv-key $1
gpg --export --armor $1 | sudo apt-key add -
exit 0
