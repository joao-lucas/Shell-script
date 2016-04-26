#!/bin/bash

 funcao (){

  clear
  echo "#--------------------------#"
  echo "#  TESTE DE CONECTIVIDADE  # "
  echo "#--------------------------#"
  echo

  echo "Inicio: " $(date +%T-%d/%m/%Y)

    for i in `cat /home/joao_lucas/Área\ de\ trabalho/sites.txt`;
    do
      echo "______________________"
      echo
      echo "Site: " $i
      DIG=$(dig +short $i)
      echo "IP(s): " $DIG
      echo "Perda de Pacotes:  `ping -c2 $i  | grep packet | cut -d ' ' -f6`"
      echo "Servidor(s) de E-mail: " `host $i  | grep mx | cut -d ' ' -f 7`

    done

  }

 funcao | tee /var/log/tconectividade.dump
