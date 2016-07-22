#/bin/bash
#######################################################################################
# Script para fazer diferentes tipos de backup
# Autor: Joao Lucas <joaolucas@linuxmail.org>
# historico: v1.0 2016/02/27  
#
# Descrição dos tipos de Backup
#       Completo: Copia todos os dados.       
#       Diferencial: Copia as alterações feitas desde o último backup completo.
#       Incremental: São copiados somente os dados alterados desde o ultimo backup.        
#
##########################################################################################  

DATA=$(date +'%Y-%m-%d-%H-%M')
PREFIX=/backup
BANNER=$( figlet -f block -c "souz4" )

function backup() {
#clear
echo -e "\033[1;34m###########################################################################\033[0m"
echo -e " \033[0;34m $BANNER \033[0m"
echo -e "\033[1;36m 1. \033[0m \033[1;33mBackup completo de um diretorio\033[0m"
echo -e "\033[1;36m 2. \033[0m \033[1;33mBackup por extensão de arquivos\033[0m"
echo -e "\033[1;36m 3. \033[0m \033[1;33mBackup da home de um usuario\033[0m"
echo -e "\033[1;36m 4. \033[0m \033[1;33mBackup de todos os usuarios\033[0m"
echo -e "\033[1;36m 5. \033[0m \033[1;33mAdicionar arquivos ou diretorios em um backup existente\033[0m" 
echo -e "\033[1;36m 99.\033[0m \033[0;31mSair\033[0m"
echo

read -p "Opção: " opt
case $opt in
        1) echo -e "\033[1;32mFazendo Backup Completo...\033[0m"
                read -p "Entre com o diretorio a ser feito o backup. Ex. /var/log: " dir
                if [ -d $dir ]
                then
                        read -p "Usar  Compressor bz2? [Y/n] " escolha
                        if [ "$escolha" = "y" ]  || [ "$escolha" = "Y" ]  || [ "$escolha" == "" ]
                        then 
                                tar -cjvf $PREFIX/bkp-$DATA.tar.bz2 $dir  
                                echo -e "\033[0;32m Salvo em: $PREFIX/bkp-$DATA.bkp \033[0m"
                                sleep 1

                        else if [ "$escolha" = "n" ] || [ "$escolha" = "N" ]
                        then
                                tar -cvf $PREFIX/bkp-$DATA.tar $dir     
                                echo -e "\033[0;32m Salvo em: $PREFIX/bkp-$DATA.bkp \033[0m"  
                                sleep 1

                        else
                                echo -e "\033[1;31m Opção Invalida! \033[0m"
                                sleep 3
                        fi
                        fi
                 else
                        echo -e "\033[0;31m O diretorio informado não existe \033[0m"
                        sleep 1
                fi
        ;;   
              
         2) echo "Fazer backup por extensão de arquivo"
                echo "Qual a extensão do arquivo? Ex: conf, log, mp3"
                read -p "Extensão: " ext
                read -p "Diretorio padrao da busca / . Deseja alterar o diretorio? [s/N] " opt
                if [ "$opt" = "s" ] || [ "$opt" = "S" ]
                then
                        echo -e "\033[0;32m Ex. /home, /etc/, /var ... \033[0m"
                        read -p "Diretorio da busca: " dir
                        if [ -d $dir ]
                        then
                                find $dir -name *.$ext | xargs tar -cvjf  $PREFIX/bkp-$DATA.tar.bz2
                                echo -e "\033[0;32m Backup criado em: $PREFIX/bkp-$DATA.tar.bz2 \033[0m"
                                sleep 3
                        else
                                echo -e "\033[0;31m Diretorio não existe \033[0m"
                                sleep 3 
                        fi
                else if [ "$opt" = "n" ] || [ "$opt" = "N" ] || [ "$opt" == "" ]
                then
                        find / -name *.$ext | xargs tar -cjf $PREFIX/bkp-$DATA.tar.bz2      
                        echo -e "\033[0;031m Backup criado em: $PREFIX/bkp-$DATA.tar.bz2 \033[0;31m"
                        sleep 1
                else
                        echo -e "\033[0;31m Opção Invalida! \033[0;31m"
                        sleep 
                fi
                fi
         ;; 
        
        3) echo "Fazendo backup de determinado usuario..."
                read -p "Nome do usuario: " user
                lst_user=$( cut -d ':' -f 1 /etc/passwd | grep -w $user )
                if [ "$lst_user" = "$user" ]
                then
                        home=$( cut -d ':' -f 6 /etc/passwd | grep -w $user )
                        tar -cjvf $PREFIX/bkp_user_$user-$DATA.tar.bz2 $home
                        echo -e "\033[0;32m Savo em: $PREFIX/bkp_user_$user-$DATA.tar.bz2 \033[0m"
                        sleep 1
                else
                        echo -e "\033[0;31m Usuário não encontrado! \033[0m"      
                        sleep 1
                fi
         ;;

        4) read -p "Deseja Fazer backup da home de todos usuarios? [S/n]" opt
                if [ "$opt" = "s" ] || [ "$opt" = "S" ] || [ $opt == "" ]
                then
                        lst_user=$( cut -d ':' -f 6 /etc/passwd )
                        tar -cjvf $PREFIX/bkp_todas_home-$DATA.tar.bz2 $lst_user 
                        echo -e "\033[0;32 Backup salvo em $PREFIX/bkp_todas_home-$DATA.tar.bz2 \033[0m"
                        sleep 1
                else
                        exit
                fi
                        ;;
                
        99) echo "Saindo..." 
                sleep 1
                exit 
         ;;          
        
        *) echo -e "\033[0;31m Opção Invalida! \033[0m"
                sleep 1
esac
}

while true
do

        usuario=$( id -u )
        if [ "$usuario" -eq "0" ]
        then
                #trap backup 2 20
                backup
        else
                echo -e "\033[0;31m Executar o script como super usuario! \033[0m"        
                sleep 5
        fi
done
