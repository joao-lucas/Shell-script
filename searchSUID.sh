#!/bin/bash
# Scrip para procurar arquivos com a permissão SUID ativo.
# Data: 20160528
# Autor: Joao Lucas <joaolucas@linuxmail.org>

find / -path '/proc' -prune -or -perm -u+s -exec ls -ld {} \; | tee suids.txt
