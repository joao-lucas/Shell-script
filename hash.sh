#!/bin/bash

# declaração do array associativo
declare -A pessoas

#preenchendo o array
pessoas=(
        ["joao"]=20
        ["maria"]=3
        ["marcos"]=28
)       

# percorrendo o array
for pessoas in "${!pessoas[@]}
do
        echo "$pessoas tem ${pessoas[$pessoas]} anos"
done

