#!/bin/bash
#
# Script para gerar senhas aleatorias e grava-las em um arquivo protegido com senha e criptografia GPG simétrica (CAST5 cipher).
#
# The MIT License (MIT)
# Copyright (c) 2016 João Lucas
#
# Date: 2017-01-30-v0.1
# Autor: João Lucas <joaolucas@linuxmail.org>
#

#               ____  __  _  ____ __    __             
#              (_ (_`|  \| |/ () \\ \/\/ /             
#             .__)__)|_|\__|\____/ \_/\_/              
# _____  ____    ____   ____ __    __ ____ _____  ____ 
# | ()_)/ () \  (_ (_` (_ (_`\ \/\/ // () \| () )| _) \
# |_|  /__/\__\.__)__).__)__) \_/\_/ \____/|_|\_\|____/
#     __  __   ____   __  _   ____   ____  ____ _____  
#    |  \/  | / () \ |  \| | / () \ / (_,`| ===|| () ) 
#    |_|\/|_|/__/\__\|_|\__|/__/\__\\____)|____||_|\_\ v0.1"
#

read -p "Dominio que utilizará a senha: " DOMINIO 
read -p "E-mail: " EMAIL
read -p "Quantidade de caracteres: " QTD_CARACTERES
read -p "Usar caracteres especiais? [S/n]:" CARACTERES_ESP
if [ "$CARACTERES_ESP" = "s" ] || [ "$CARACTERES_ESP" = "S"  ] || [ "$CARACTERES_ESP" = "" ]
then
	CHAVE_SECRETA=$(tr -dc 'a-zA-Z0-9-_!@#$%&*+'  < /dev/urandom | head -c $QTD_CARACTERES)	
	echo -e "\n [\033[0;32m OK\033[0m ] Senha gerada com sucesso!"

else if [ "$CARACTERES_ESP" = "n" ] || [ "$CARACTERES_ESP" = "N" ]
then
	CHAVE_SECRETA=$(tr -dc 'A-Za-z0-9_' </dev/urandom | head -c $QTD_CARACTERES)
	echo -e "\n [\033[0;32m OK\033[0m ] Senha gerada com sucesso!"

else
	echo -e "\n [\033[0;31m FALHA\033[0m ] Opção Invalida"
	exit 1
fi
fi

#echo "Chave secreta: $CHAVE_SECRETA"

cat > .password << EOF
DOMINIO=$DOMINIO
E-MAIL=$EMAIL
SENHA=$CHAVE_SECRETA
ULTIMA_ALTERACAO=$(date +'%d-%m-%Y')

EOF

ls -la | egrep "gpg$" &> /dev/null
if [ $? -eq 0 ]
then
	gpg -d --decrypt .password.gpg 1>> .password 2> /dev/null
	rm -f password.gpg 2>&1 /dev/null
	gpg -c .password		
	echo -e "\n [\033[0;32m OK\033[0m ] Arquivo .password.gpg atualizado com sucesso!"
else	
	gpg -c .password
	echo -e "\n [\033[0;32m OK\033[0m ] Arquivo .password.gpg criado com sucesso!"
fi

rm .password 2> /dev/null
