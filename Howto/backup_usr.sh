#!/bin/bash
## Programa de criar backups individuais para cada usuario
lista=`cat /etc/passwd`
for usr in $lista 
do
        login=$( echo $usr | cut -d : -f 1 )
        homedir=$( echo $usr | cut -d : -f 6 )
        tar -cjvf /backup/bkp-$login.tar.bz2 $homedir
done 
