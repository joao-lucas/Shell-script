#!/bin/bash
# Este script automatiza a remoção de todoas as shells validas de todos os usuários, exeto aqueles que forem
# especificado como membro do grupo GROUP_ADMIN

# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

# Os usuários administradores deverao ser ignorados pelo for atravez da opção -v do grep
for USER in $(cat /etc/passwd | cut -d ":" -f 1 | grep -v root | grep -v joao)
do 
	usermod -s /bin/false $USER
done 	
