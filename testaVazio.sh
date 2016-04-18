#!/bin/bash

echo "TESTANDO EXISTENCIA DO ARQUIVO..."
if test -e $1
then
	echo "Arquivo existe!"
else
	echo "Arquivo NÃO existe!"
fi

echo "TESTANDO SE TEM CONTEUDO DENTRO DO ARQUIVO..."
if test -z $1
then
	echo "Arquivo Vazio!"
else
	echo "Arquivo POSSUI conteudo!"
fi	
