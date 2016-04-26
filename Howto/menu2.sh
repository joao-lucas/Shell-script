#!/bin/bash
## MENU

menu () {
        clear
        echo "
        1. Cria usuario
        2. Consulta usuario
        3. Exclui usuario
        4. Adiciona usuario ao grupo        
        5. Sair "
read -p "Opção: " opt        
        
        case $opt in
                1) read -p  "Qual o login? " login
                        useradd -m -d /home/$login -s /bin/bash $login
                        ;;
                2) read -p "Qual o login do usuario? " login
                        grep -i $login /etc/passwd | tr a-z A-Z | tr : \\t
                        read -p "Digite ENTER pra continuar" enter
                        ;;
                3) read -p "Qual o login do usuario a ser excluido? " login
                        userdel -r $login
                        ;;
                4) read -p "Qual o login do usuario? " login
                        read -p "Adicionar $login em qual grupo? " grupo
                        usermod -G $grp -a $login
                        ;;
                5) exit
                        ;;
                *) echo "Digite uma opção valida" 
        esac
}
trap menu 2 20
while true 
do
        menu
done
