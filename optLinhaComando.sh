#!/bin/bash

MSG_AJUDA="USO: meu_script [OPÇÕES] [ARQUIVO]"
VERSAO="V1.0"

if test "$1" = "-h"
then
        echo "$MSG_AJUDA"
        exit 0
elif test "$1" = "-V"
then
        echo "$VERSAO"
fi
