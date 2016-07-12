#!/bin/bash
# Script para colocar ou remover a permissão de execução dos diretorios /var e /tmp
# Author: João Lucas <joaolucas@linuxmail.org>
# Data:1016-07-17
#

case $1 in
  start)
    mount -o remount,rw,noexec /var
    mount -o remount,rw,noexec /tmp
    mount
    echo "Partições sem permissão de execução!"
    ;;
  
  stop)
    mount -o remount,rw,exec /var
    mount -o remount,rw,exec /tmp
    mount
    echo "Partições com permissão de execução"
    ;;
    
    *) echo "[ FALHA ] Use: $0 {start|stop}"
    exit 0
  
  esac
