#!/bin/bash

echo "Digite o nome do arquivo e a palavra: "
read arquivo palavra

if grep  $palavra $arquivo
then
        echo "A palavra $palavra existe no arquivo $arquivo"
fi

