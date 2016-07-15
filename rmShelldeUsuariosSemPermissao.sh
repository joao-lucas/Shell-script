#!/bin/bash
# Este script automatiza a remoção de todoas as shells validas de todos os usuários, exeto aqueles que forem
# especificado como membro do grupo GROUP_ADMIN

# Autor: Joao Lucas <joaolucas@linuxmail.org>
#

# Grupo dos usuários que podem fazer acesso a shells no sistema
GRUPO_ADMIN=administradores
USERS=$(cat /etc/passwd | cut -d ":" -f 1)	
USERS_PERM=$(cat /etc/group | grep  $GRUPO_ADMIN | cut -d ":" -f 4)

echo -e "\nGrupo de Administradores:\n $GRUPO_ADMIN"
echo -e "\nUsuarios:\n $USERS"
echo -e "\nUsuários Administradores:\n $USERS_PERM"
#	usermod -s /bin/false $USER
#do 	
