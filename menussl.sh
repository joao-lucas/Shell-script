#!/bin/bash

user=$(dialog --stdout --menu 'MiTM' 0 0 0      1 um 2 dois 3 treis)
echo voce escolheu o numero $user
