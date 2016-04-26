#!/bin/bash

usuario=`id -u`
if [ "$usuario" == "0" ]
then
        echo "Usuario é root"
else
        echo "Usuario não é root"
fi
