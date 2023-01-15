#!/bin/bash
######################################################################################################
#
#  Variables
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mEdit Nightscout variables                                                                         \x1b[0m"

prompt=0

while [ $prompt = 0 ]
do
  HEIGHT=16
  WIDTH=40
  CHOICE_HEIGHT=9
  BACKTITLE="Nightscout Docker VPS Management"
  TITLE="Nightscout Variables"
  MENU="Use up/down arrows to select:"
  OPTIONS=(1 "API Secret"
		 2 "Enable plugins"
		 3 "Show plugins"
		 4 "Authentication"
		 5 "Units"
		 6 "Dexcom bridge"
		 7 "Alerts and alarms"
         8 "Device status"
		 9 "Visualizations")

  CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)
		
  clear
  case $CHOICE in
      1) # API_SECRET
        apisecret= "`grep "API_SECRET" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        newapisecret=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Save API_SECRET" --title "Setup your API_SECRET" \
       --inputbox "This is the password to enter your Nightscout site and settings.\nIt must be at least 12 characters long.\nUse only letters and numbers, no spaces." 10 50 $apisecret\
        3>&1 1>&2 2>&3 3>&- )
        sudo sed -i "s/$apisecret/$newapisecret/" /nightscout/docker-compose.yml
        ;;
      2) # ENABLE
        ;;
      3) # SHOW_PLUGINS
        ;;
      4) # AUTH_DEFAULT_ROLES
        ;;
      5) # DISPLAY_UNITS
        ;;
      6) # BRIDGE
        ;;
      7) # Alerts and alarms
        ;;
      8) # DEVICESTATUS
        ;;
      9) # Visualizations
        ;;
  esac
done
