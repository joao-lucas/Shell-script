#!/bin/bash
clear
#####################################
nome=a
masc=0
femi=0
desc=0
maior=0
menor=0
idoso=0
idesc=0
####################################

while [ $nome != "fim" ]
  do
        echo -n "Digite seu nome: "
        read nome
        if [ $nome != "fim" ]
          then
                echo "$nome" >> ~/arquivo.original
        else
                grep -vi "fim" ~/arquivo.original > ~/arquivo.tmp
                mv ~/arquivo.tmp arquivo.original
        break
        fi
                echo -n "Digite seu sexo: "
                read sexo
                if [ $sexo = "M" ] || [ $sexo = "m" ]
                  then
                        masc=$(expr $masc + 1)
                elif [ $sexo = "F" ] || [ $sexo = "f" ]
                  then
                        femi=$(expr $femi + 1)
                else
                        desc=$(expr $desc + 1)
                fi
                        echo -n "Digite sua idade: "
                        read idade
                        if [ $idade -lt 18 -a $idade -ge 0 ]
                          then
                                menor=$(expr $menor + 1)
                        elif [ $idade -ge 18 -a $idade -le 59 ]
                          then
                                maior=$(expr $maior + 1)
                        elif [ $idade -gt 59 ]
                          then
                                idoso=$(expr $idoso + 1)
                        elif [ $idade -lt 0 ]
                          then
                                idesc=$(expr $idesc + 1)
                fi
  done
echo
echo "Total de pessoas cadastradas: $(wc -l < ~/arquivo.original)"
echo "Total de pessoas do sexo masculino: $(echo $masc)"
echo "Total de pessoas do sexo feminino: $(echo $femi)"
echo "Total de pessoas que erraram o sexo: $(echo $desc)"
echo "Total de pessoas menores de idade: $(echo $menor)"
echo "Total de pessoas maiores de idade: $(echo $maior)"
echo "Total de idosos: $(echo $idoso)"
echo "Total de pessoas que erraram a idade: $(echo $idesc)"
echo
rm ~/arquivo.original
