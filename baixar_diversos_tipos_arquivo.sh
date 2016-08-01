#!/bin/bash

# Script para fazer download de musicas mp3 do youtube, vimeo, soundclound, facebook e muitos outros sites
# Data: 28/07/2016
# Requerimentos: youtube-dl
# Autor: João Lucas <joaolucas@linuxmail.org>
# Github: https://gitbub.com/joao-lucas
#
 
# XXX - a função  baixar_series ainda não esta funcionando, mas esta com a sintaxe de acordo com o README do projeto do github

data=`date +'%d-%m-%Y-%H-%M'`
arq=/tmp/$data.ytb-dl
#dir_videos=/home/joao_lucas/Vídeos/

menu(){
        echo "1. Baixar músicas mp3"
        echo "2. Baixar playlists mp3"
        echo "3. Baixar videos/filmes/cursos"
        echo "4. Baixar serie"
        echo "5. Baixar videos dos cursos da udemy"
        echo "99. sair"
        read -p "> Opção: " opt

       case $opt in
               1) baixar_musicas_mp3 ;;
               2) baixar_playlist_mp3 ;;
               3) baixar_videos ;;
               4) baixar_series ;;
               5) baixar_cursos_udemy ;;
               99) echo "Saindo ..."
        esac
}

# baixa músicas e converte para mp3 
baixar_musicas(){
        read -p "> Entre com o link da musica: " link_musica
        youtube-dl --extract-audio --audio-format  mp3 -c -o '%(title)s.%(ext)s' $link_musica
        if [ $? -eq 0 ]
        then
                echo -e "\n [\033[0;32m OK\033[0m ] Música baixada com sucesso!"
        else                
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em baixar a música! "
        fi

}

# baixa playlists e converte para mp3
baixar_playlist_mp3(){
        read -p "> Entre com o link da playlist: " link_playlist
        youtube-dl -c -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' --audio-format mp3 $link_playlist
        if [ $? -eq 0 ]
        then
                echo -e "\n [\033[0;32m OK\033[0m ] Playlist baixado com sucesso!"
        else                
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros ao baixar a playlist!"
        fi
}

# baixa vídeos, playlists, filmes e series 
baixar_videos(){
        read -p "> Entre com o link do video/playlist/filme: " link_video
        youtube-dl -c -o '/home/joao_lucas/Vídeos/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $link_video

        if [ $? -eq 0 ]
        then
                echo -e "\n [\033[0;32m OK\033[0m ] Download feito com sucesso!"
        else                
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros em fazer o download!"
        fi
}

# baixa videos dos cursos da udemy, é necessário estar cadastrado no site e possuir acesso aos cursos ou pelo menos ter acesso aos links dos videos 
baixar_cursos_udemy(){
        user=willy_hdb@hotmail.com
        password=linuxforense
        read -p "> Entre com o link da video-aula: " link_curso
        youtube-dl -u $user -p $password -c -o '/home/joao_lucas/Vídeos/Shell-script/%(title)s.%(ext)s' $link_curso
        if [ $? -eq 0 ]
        then
                echo -e "\n [\033[0;32m OK\033[0m ] Vídeo-aula baixada com sucesso!"
        else                
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram erros!"
        fi
}

# baixar series, ainda não esta funcionando
baixar_series(){
read -p "Informe o link da serie: " link_serie
youtube-dl -c -o '/home/joao_lucas/Vídeos/%(series)s/%(season_number)s - %(season)s/%(episode_number)s - %(episode)s.%(ext)s' $link_serie
}

if [ $# -eq 1 ]
then
        youtube-dl --extract-audio --audio-format mp3 -c -o '%(title)s.%(ext)s' $1 2> /dev/null | tee $arq
        if [ $? -eq 0 ]
        then
                nome_mp3=`cat $arq | grep .mp3$ | cut -d: -f2 | cut -d- -f1,2`.mp3
                echo -e "\n [\033[0;32m OK\033[0m ] $nome_mp3 baixado com sucesso!"
        else
                echo -e "\n [\033[0;31m FALHA\033[0m ] Ocorreram falhas em baixar o arquivo mp3!"
        fi
        rm -f *.ytb-dl

elif [ $# -ge 2 ]
then
        echo "USO: $0 <URL>  - Baixar musicas mp3"
        echo "USO: $0  - Para entrar no menu" 
else
        menu
fi
