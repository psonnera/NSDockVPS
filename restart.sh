#!/bin/bash
######################################################################################################
#
#  Restart Nightscout
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

clear
echo -e "\x1b[37;44mRiavvio di Nightscout... aspetta                                                                  \x1b[0m"
cd /nightscout
#docker compose down
echo -e "\x1b[37;44mAspetta fino a 5 minuti per avere Nightscout disponibile                                          \x1b[0m"
nohup sudo docker compose up -d &	# run it in background
cd /nightscout/NSDockVPS
