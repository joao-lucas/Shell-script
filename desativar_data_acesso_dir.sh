#!/bin/bash
# Toda vez que acessamos um arquivo ou diretório no Linux a data e hora e atualizada. Em máquinas normais isto é normal, porém em servidores onde o acesso a arquivos é constante(como no diretório /var/spool em servidores de email ou /usr/ em servidores diskless) é recomendável desativar esta característica. Isto reduzirá a quantidade de buscas das cabeças do disco rigido para a atualização desde atributo e consequentemente aumentará a performace na gravação de arquivos(o disco rigido usa o sistema mecânico para ler/gravar dados, muito mais lento que a memória RAM eletrônica).

chattr -R +A /var/spool
# O atributo +A desativa a gravação da data de acesso dos arquivos e sub-diretorios dentro de /var/spool. Para desativar a atualização da data de acesso de toda a partição, você pode incluir a opção de montagem noatime no seu /etc/fstab
# /dev/sda1	/var/spool	ext4	defaults,noatime	0	1

# OBS: O Linux utiliza três atributos de data para controle de arquivos:
# atime - Data/Hora de acesso: é atualizada tpda vez que o arquivo é lido ou executado.
# mtime - Data/Hora da modificação, atualizando sempre que alguma modificação ocorrer no arquivo ou no conteúdo do diretório. Esta é a mais interessante que a ctime principalmente quando temos hardlinks.
# ctime - Data/Hora da ultima modificação no inodo do arquivo.

# Em partições onde a gravação é frequente, como na própria /var/spoll, a desativação do atributo atime além de melhorar o desempenho do disco, não fará muita falta.

# Fonte: Guia FOCA Linux Avançado   
