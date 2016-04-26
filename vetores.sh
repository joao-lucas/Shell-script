#!/bin/bash

linguagem[0]="shell script"
linguagem[1]="python"
linguagem[2]="C"
linguagem[3]="hasckell"

# obtendo o tamanho do vetor

tam_vet=${#linguagem[@]}

 echo "O vetor possui $tam_vet elementos"

 linguagem[3]="php"

 #mostrando todos os elementos do vetor

 for((i=0; i<${tam_vet}; i++))
 do
         echo "linguagem[$i]; ${linguagem[$i]}"
 done
