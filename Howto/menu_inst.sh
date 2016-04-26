#!/bin/bash
### Programa de menu de instalações
clear
echo "
        1. Instalar um pacote
        2. Remover um pacote
        3. Consultar um pacote instalado
        4. Atualizar o APT
        5. Sair do programa
"
read -p "Opção:" opt

case $opt in
        1) read -p "Qual pacote instalar? " pct
                apt-get install $pct
        ;;
        2) read -p "Qual pacote remover? " pct
                dpkg -r $pct
                ;;
        3) read -p "Qual pacote a ser consultado? " pct
                dpkg -p $pct
                ;;
        4) apt-get update
                ;;
        5) exit 0
                ;;
        *) echo "Opção não encontrada!"
esac
