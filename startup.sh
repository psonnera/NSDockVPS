#!/bin/bash
######################################################################################################
#
#  Startup script
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mWelcome to Nightscout.                                                                            \x1b[0m"
cd /nightscout/NSDockVPS

# We don't want to run Nightscout as root

username=${SUDO_USER:-$USER}
if [ $username = "root" ]
  then
  sudo bash ./user.sh
  else
  sudo bash ./menu.sh
fi