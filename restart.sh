#!/bin/bash
######################################################################################################
#
#  Restart Nightscout
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

clear
echo -e "\x1b[37;44mRestarting Nightscout... please wait                                                              \x1b[0m"
cd /nightscout
sudo docker compose down
sudo docker compose pull
echo -e "\x1b[37;44mNow wait 5 minutes until Nightscout will be available again                                       \x1b[0m"
nohup sudo docker compose up -d &	# run it in background
cd /nightscout/NSDockVPS
