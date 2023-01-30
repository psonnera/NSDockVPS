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
#docker compose down
echo -e "\x1b[37;44mNow wait 5 minutes until Nightscout will be available again                                       \x1b[0m"
nohup sudo docker compose up -d &	# run it in background
dialog --nook --nocancel --pause "Now wait up to 5 minutes\nfor your Nightscout site to update." 7 40 10
cd /nightscout/NSDockVPS
