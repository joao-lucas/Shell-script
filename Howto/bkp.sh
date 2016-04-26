#!/bin/bash
## Programa de backup

data=`date +'%Y-%m-%d-%H-%M'`
ext=conf
lista=$(( find / -name *.$ext ))
tar -cjf /backup/bkp-$data.tar.bz2 $lista
