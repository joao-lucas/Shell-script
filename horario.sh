#!/bin/bash

while true
do
        clear 
        echo
        echo "____________________________________________________" 
        #horario=`date | cut -d ' ' -f 5 | cut -d : -f 1,2 | figlet -f block | lolcat`

        echo
        horario=`date | cut -d ' ' -f 4 | cut -d : -f 1,2 | toilet --font mono12  --termwidth`
        #echo -e "\033[1;36m $horario \033[0m" 
        echo -e "\033[1;34m $horario \033[0m"
        #dia=`date +'%Y %b %d' | toilet --font future`
        dia=`date +'%Y-%b-%d' | figlet -f term`
        #echo -e "               \033[1;33m $dia \033[0m"

        #data=`date | cut -d ' ' -f 1,2,3,4 | toilet --font future`
        echo
        echo
        echo -e "\033[0;32m                     $dia \033[0m"
        echo "____________________________________________________"
        sleep 5

done
