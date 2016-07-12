#!/bin/bash
# Script para procurar arquivos com a permissão SUID ativo.
# Author: Joao Lucas <joaolucas@linuxmail.org>
# Data: 2016-07-12
#

find / -path '/proc' -prune -or -perm -u+s -exec ls -l {} \; | tee suids.txt
