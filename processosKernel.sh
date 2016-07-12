#!/bin/bash
# É comum em um sistema que esteja corrompido que os comandos top, ps e pstree sejam alterados para esconder
#algum processo malicioso.
#
# Os processos podem ser checados diretamente no kernel atraves da leitura da lista de processos.
# 
# Data: 20160528
# Autor: Joao Lucas <joaolucas@linuxmail.org>
# 

cat /proc/*/stat | awk '{print $1,$2}' | tee procKernel.txt 
