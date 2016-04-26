#!/bin/bash
escolha="sim"

while [ $escolha != "nao" ]
do
        clear
        echo "____________________________________________"
        echo "Escolha uma das opçoes abaixo"
        echo "____________________________________________"
        echo "(1) Processador"
        echo "(2) Memoria RAM"
        echo "(3) Uso do HD"
        echo "(4) Sistema Operacional"
        echo "(5) Arquitetura da maquina"
        read opcao

        case $opcao in
                1) cat /proc/cpuinfo | grep "model name" | uniq | cut -c 13-60 
                        ;;
                2) free -h
                        ;;
                3) df -hT
                        ;;
                4) uname -o; lsb_release -d | cut -c 14-60
                        ;;
                5) uname -p
                        ;;
                *) echo "Opcao invalida"
        esac

        echo "Continuar executando o aplicativo? (sim ou nao)"
        read escolha
done
