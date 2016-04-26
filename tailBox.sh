#!/bin/bash
tail -f /var/log/messages.log > out &
dialog --title 'Monitorando mensagens do sistema' --tailbox out 0 0
