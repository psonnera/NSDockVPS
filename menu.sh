#!/bin/bash
######################################################################################################
#
#  Main menu
#
#  Credits: https://github.com/jamorham/nightscout-vps/blob/vps-1/menu.sh
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mNightscout Docker VPS Initial configuration                                                       \x1b[0m"

# check this is the first run or not

cd /nightscout/NSDockVPS

if [ ! "`sudo docker ps -a | grep "bash"`" ] # any container running?
then
  sudo ./initial.sh
fi

while :
do
  if [ -f config_dns.txt ]
    then
    HEIGHT=15
    WIDTH=40
    CHOICE_HEIGHT=3
    BACKTITLE="Nightscout Docker VPS Management"
    TITLE="Nightscout Management"
    MENU="Use up/down arrows to select:"
    OPTIONS=(1 "View Nightscout status"
         2 "Exit to command prompt")

    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)
		
    clear
    case $CHOICE in
        1)
            echo "Yes"
            ;;
        2)
            exit
            ;;
    esac
  fi
done
