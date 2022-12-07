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

echo -e "\x1b[37;44mStarting the main menu                                                                            \x1b[0m"

cd /nightscout
while :
do
  if [ ! -s config_dns.txt ]
    then
    HEIGHT=15
    WIDTH=40
    CHOICE_HEIGHT=3
    BACKTITLE="Nightscout Docker VPS Initial configuration"
    TITLE="Nightscout setup"
    MENU="Use up/down arrows to select:"
    OPTIONS=(1 "Configure server name"
         2 "View status")

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
            echo "You chose Option 1"
            ;;
        2)
            echo "You chose Option 2"
            ;;
        3)
            echo "You chose Option 3"
            ;;
    esac
  fi
done