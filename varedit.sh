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
  HEIGHT=18
  WIDTH=40
  CHOICE_HEIGHT=11
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
		 A "Advanced Edit Config"
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
		  sudo ./initial.sh	# Deploy the changes
		  else
		  dialog --colors --msgbox " Cancelled or invalid. API_SECRET unchanged." 5 50
		fi
        ;;
      2) # ENABLE
	    ./enable.sh
		sudo ./initial.sh	# Deploy the changes
        ;;
      3) # SHOW_PLUGINS
	    ./show.sh
		sudo ./initial.sh	# Deploy the changes
        ;;
      4) # AUTH_DEFAULT_ROLES
        dialog --clear --backtitle "$BACKTITLE" --title "Setup Authentication" \
        --no-label "denied" --yes-label "readable" --yesno "\
You can remove unauthorized access to your Nightscout page with denied.\n\
Setting it to readable makes your page visible to anybody." 10 50
        status=$?
		if [ $status = 0 ]
		  then
		  sudo sed -i "s/AUTH_DEFAULT_ROLES: denied/AUTH_DEFAULT_ROLES: readable/" /nightscout/docker-compose.yml
		fi
		if [ $status = 1 ]
		  then
		  sudo sed -i "s/AUTH_DEFAULT_ROLES: readable/AUTH_DEFAULT_ROLES: denied/" /nightscout/docker-compose.yml
		fi
		sudo ./initial.sh	# Deploy the changes
        ;;
      5) # DISPLAY_UNITS
        dialog --clear --backtitle "$BACKTITLE" --title "Setup Display units" \
        --no-label "mg/dl" --yes-label "mmol/l" --yesno "\
Choose the measurement unit for your site" 10 50
        status=$?
		if [ $status = 0 ]
		  then
		  sudo sed -i "s+DISPLAY_UNITS: mg/dl+DISPLAY_UNITS: mmol/l+" /nightscout/docker-compose.yml
		fi
		if [ $status = 1 ]
		  then
		  sudo sed -i "s+DISPLAY_UNITS: mmol/l+DISPLAY_UNITS: mg/dl+" /nightscout/docker-compose.yml
		fi
		sudo ./initial.sh	# Deploy the changes
        ;;
      6) # BRIDGE
        oldbridgeuser="`grep "BRIDGE_USER_NAME:" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        oldbridgepwd="`grep "BRIDGE_PASSWORD:" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        oldbridgesrv="`grep "BRIDGE_SERVER:" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        dexdialog=$(dialog --clear --backtitle "$BACKTITLE" --title "Setup Dexcom bridge" \
--form " Enter your Dexcom credentials below (those you use on the phone connected to the sensor).\n\
Remember you need an active Dexcom follower.\nServer must be US or EU." 12 50 0 \
"Username: " 1 1 "$oldbridgeuser" 1 14 50 0 "Password:" 2 1 "$oldbridgepwd" 2 14 31 0 \
"Server:" 3 1 "$oldbridgesrv" 3 14 3 0 2>&1 >/dev/tty)
        status=$?
        if [ $status = 0 ]
		then
		  dexshare=($dexdialog)
		  bridgeuser=${dexshare[0]}
		  bridgepwd=${dexshare[1]}
		  bridgesrv=${dexshare[2]}
		  sudo sed -i "s/BRIDGE_USER_NAME: $oldbridgeuser/BRIDGE_USER_NAME: $bridgeuser/" /nightscout/docker-compose.yml
		  sudo sed -i "s/BRIDGE_PASSWORD: $oldbridgepwd/BRIDGE_PASSWORD: $bridgepwd/" /nightscout/docker-compose.yml
		  sudo sed -i "s/BRIDGE_SERVER: $oldbridgesrv/BRIDGE_SERVER: $bridgesrv/" /nightscout/docker-compose.yml
		  sudo sed -i "s/#BRIDGE_USER_NAME/BRIDGE_USER_NAME/" /nightscout/docker-compose.yml
		  sudo sed -i "s/#BRIDGE_PASSWORD/BRIDGE_PASSWORD/" /nightscout/docker-compose.yml
		  sudo sed -i "s/#BRIDGE_SERVER/BRIDGE_SERVER/" /nightscout/docker-compose.yml
		  sudo ./initial.sh	# Deploy the changes
		  if [ ! "`grep "ENABLE:" /nightscout/docker-compose.yml | grep "bridge"`" ]
		  then
		    dialog --colors --msgbox " Remember to enable bridge (Share to Nightscout bridge)" 5 60
		  fi
		fi
        ;;
      7) # Alerts and alarms
        ;;
      8) # DEVICESTATUS
        ;;
      9) # Visualizations
        ;;
      A) # Edit file
	    sudo nano /nightscout/docker-compose.yml
        ;;
      0) # Back
	    prompt=1
	    exit
        ;;
  esac
done

sudo ./menu.sh		# Return to menu
