#!/bin/bash
## Programa de backup
data=`date +'%Y-%m-%d-%H-%M'`
lista=$(( cut -d ':' -f 6 /etc/passwd ))
tar -cjf /backup/bkp_usr-$data.tar.bz2 $lista
