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
  HEIGHT=17
  WIDTH=40
  CHOICE_HEIGHT=10
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
		 9 "Visualizations"
		 0 "Return to main menu")

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
        apisecret="`grep "API_SECRET" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        newapisecret=$(dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Save API_SECRET" --title "Setup your API_SECRET" \
       --inputbox "This is the password to enter your Nightscout site and settings.\n\
It must be at least 12 characters long.\nUse only letters and numbers, no spaces." 10 50 $apisecret\
        3>&1 1>&2 2>&3 3>&- )
        if [ ${#newapisecret} > 11 ]
		  then
		  sudo sed -i "s/$apisecret/$newapisecret/" /nightscout/docker-compose.yml
		  else
		  dialog --colors --msgbox " Cancelled or invalid. API_SECRET unchanged." 5 50
		fi
        ;;
      2) # ENABLE
        ;;
      3) # SHOW_PLUGINS
        ;;
      4) # AUTH_DEFAULT_ROLES
        dialog --clear --backtitle "$BACKTITLE" --title "Setup Authentication" \
        --no-label "denied" --yes-label "readable" --yesno "\
You can remove unauthorized access to your Nightscout page with denied.\n\
Setting it to readable makes your page visible to anybody." 10 50
        status=$?
		if [ status = TRUE ]
		  then
		  sudo sed -i "s/AUTH_DEFAULT_ROLES: denied/AUTH_DEFAULT_ROLES: readable/" /nightscout/docker-compose.yml
		  sudo sed -i "s/AUTH_DEFAULT_ROLES:denied/AUTH_DEFAULT_ROLES: readable/" /nightscout/docker-compose.yml
		fi
		if [ status = FALSE ]
		  then
		  sudo sed -i "s/AUTH_DEFAULT_ROLES: readable/AUTH_DEFAULT_ROLES: denied/" /nightscout/docker-compose.yml
		  sudo sed -i "s/AUTH_DEFAULT_ROLES:readable/AUTH_DEFAULT_ROLES: denied/" /nightscout/docker-compose.yml
		fi
        ;;
      5) # DISPLAY_UNITS
        dialog --clear --backtitle "$BACKTITLE" --title "Setup Display units" \
        --no-label "mg/dl" --yes-label "mmol/l" --yesno "\
Choose the measurement unit for your site" 10 50
        status=$?
		if [ status = TRUE ]
		  then
		  sudo sed -i "s+DISPLAY_UNITS: mg/dl+DISPLAY_UNITS: mmol/l+" /nightscout/docker-compose.yml
		  sudo sed -i "s+DISPLAY_UNITS:mg/dl+DISPLAY_UNITS: mmol/l+" /nightscout/docker-compose.yml
		fi
		if [ status = FALSE ]
		  then
		  sudo sed -i "s+DISPLAY_UNITS: mmol/l+DISPLAY_UNITS: mg/dl+" /nightscout/docker-compose.yml
		  sudo sed -i "s+DISPLAY_UNITS:mmol/l+DISPLAY_UNITS: mg/dl+" /nightscout/docker-compose.yml
		fi
        ;;
      6) # BRIDGE
        ;;
      7) # Alerts and alarms
        ;;
      8) # DEVICESTATUS
        ;;
      9) # Visualizations
        ;;
      0) # Back
	    exit
        ;;
  esac
done

sudo ./initial.sh	# Deploy the changes
sudo ./menu.sh		# Return to menu
