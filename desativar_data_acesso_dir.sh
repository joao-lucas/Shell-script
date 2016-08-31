#!/bin/bash
# Toda vez que acessamos um arquivo ou diret�rio no Linux a data e hora e atualizada. Em m�quinas normais isto � normal, por�m em servidores onde o acesso a arquivos � constante(como no diret�rio /var/spool em servidores de email ou /usr/ em servidores diskless) � recomend�vel desativar esta caracter�stica. Isto reduzir� a quantidade de buscas das cabe�as do disco rigido para a atualiza��o desde atributo e consequentemente aumentar� a performace na grava��o de arquivos(o disco rigido usa o sistema mec�nico para ler/gravar dados, muito mais lento que a mem�ria RAM eletr�nica).

chattr -R +A /var/spool
# O atributo +A desativa a grava��o da data de acesso dos arquivos e sub-diretorios dentro de /var/spool. Para desativar a atualiza��o da data de acesso de toda a parti��o, voc� pode incluir a op��o de montagem noatime no seu /etc/fstab
# /dev/sda1	/var/spool	ext4	defaults,noatime	0	1

# OBS: O Linux utiliza tr�s atributos de data para controle de arquivos:
# atime - Data/Hora de acesso: � atualizada tpda vez que o arquivo � lido ou executado.
# mtime - Data/Hora da modifica��o, atualizando sempre que alguma modifica��o ocorrer no arquivo ou no conte�do do diret�rio. Esta � a mais interessante que a ctime principalmente quando temos hardlinks.
# ctime - Data/Hora da ultima modifica��o no inodo do arquivo.

# Em parti��es onde a grava��o � frequente, como na pr�pria /var/spoll, a desativa��o do atributo atime al�m de melhorar o desempenho do disco, n�o far� muita falta.

# Fonte: Guia FOCA Linux Avan�ado   
