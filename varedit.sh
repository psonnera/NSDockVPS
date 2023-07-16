#!/bin/bash
######################################################################################################
#
#  Variables
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mEdita le variabili Nightscout                                                                     \x1b[0m"

prompt=0

while [ $prompt = 0 ]
do
  HEIGHT=18
  WIDTH=40
  CHOICE_HEIGHT=11
  BACKTITLE="Gestione Nightscout Docker VPS"
  TITLE="Variabili Nightscout"
  MENU="Usa le frecce su/giu per selezionare:"
  OPTIONS=(1 "API Secret"
		 2 "Abilita plugins"
		 3 "Mostra plugins"
		 4 "Autenticazione"
		 5 "Unita"
		 6 "Dexcom share"
		 7 "Allarmi"
         8 "Stato dispositivo"
		 9 "Visualizzazioni"
		 A "Configurazione avanzata"
		 0 "Torna al menu principale")

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
       --nocancel --ok-label "Salva API_SECRET" --title "Imposta API_SECRET" \
       --inputbox "Questa e la password del tuo sito Nightscout.\n\
Minimo 12 caratteri.\nSolo lettere e numeri, no spazi." 10 50 $apisecret\
        3>&1 1>&2 2>&3 3>&- )
        if [ ${#newapisecret} > 11 ]
		  then
		  sudo sed -i "s/$apisecret/$newapisecret/" /nightscout/docker-compose.yml
		  sudo ./restart.sh	# Deploy the changes
		  else
		  dialog --colors --msgbox " Cancellato o invalido. API_SECRET non cambiato." 5 50
		fi
        ;;
      2) # ENABLE
	    ./enable.sh
		sudo ./restart.sh	# Deploy the changes
        ;;
      3) # SHOW_PLUGINS
	    ./show.sh
		sudo ./restart.sh	# Deploy the changes
        ;;
      4) # AUTH_DEFAULT_ROLES
        dialog --clear --backtitle "$BACKTITLE" --title "Imposta Autenticazione" \
        --no-label "privato" --yes-label "pubblico" --yesno "\
Puoi remuovere gli accessi indesiderati a Nightscout con privato.\n\
Pubblico lo rende visibile a tutti." 10 50
        status=$?
		if [ $status = 0 ]
		  then
		  sudo sed -i "s/AUTH_DEFAULT_ROLES: denied/AUTH_DEFAULT_ROLES: readable/" /nightscout/docker-compose.yml
		fi
		if [ $status = 1 ]
		  then
		  sudo sed -i "s/AUTH_DEFAULT_ROLES: readable/AUTH_DEFAULT_ROLES: denied/" /nightscout/docker-compose.yml
		fi
		sudo ./restart.sh	# Deploy the changes
        ;;
      5) # DISPLAY_UNITS
        dialog --clear --backtitle "$BACKTITLE" --title "Impostazione unita" \
        --yes-label "mg/dl" --no-label "mmol/l" --yesno "\
Scegli le unita del tuo sito." 10 50
        status=$?
		if [ $status = 1 ]
		  then
		  sudo sed -i "s+DISPLAY_UNITS: mg/dl+DISPLAY_UNITS: mmol/l+" /nightscout/docker-compose.yml
		fi
		if [ $status = 0 ]
		  then
		  sudo sed -i "s+DISPLAY_UNITS: mmol/l+DISPLAY_UNITS: mg/dl+" /nightscout/docker-compose.yml
		fi
		sudo ./restart.sh	# Deploy the changes
        ;;
      6) # BRIDGE
        oldbridgeuser="`grep "BRIDGE_USER_NAME:" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        oldbridgepwd="`grep "BRIDGE_PASSWORD:" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        oldbridgesrv="`grep "BRIDGE_SERVER:" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
        dexdialog=$(dialog --clear --backtitle "$BACKTITLE" --title "Imposta Dexcom Share" \
--form " Digita le credenziali che usi nel telefonino collegato al sensore.\n\
Ricordati che devi avere un follower attivo.\nIl server deve essere EU (o US)." 12 50 0 \
"Utente: " 1 1 "$oldbridgeuser" 1 14 50 0 "Password:" 2 1 "$oldbridgepwd" 2 14 31 0 \
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
		  sudo ./restart.sh	# Deploy the changes
		  if [ ! "`grep "ENABLE:" /nightscout/docker-compose.yml | grep "bridge"`" ]
		  then
		    dialog --colors --msgbox " Ricordati di abilitare il plugin bridge." 5 60
		  fi
		fi
        ;;
      7) # Alerts and alarms
	    ./alarms.sh
		sudo ./restart.sh	# Deploy the changes
        ;;
      8) # DEVICESTATUS
        ;;
      9) # Visualizations
        ;;
      A) # Edit file
	    sudo nano /nightscout/docker-compose.yml
		sudo ./restart.sh	# Deploy the changes
        ;;
      0) # Back
	    prompt=1
	    exit
        ;;
  esac
  if [ $prompt = 1 ]
  then
    exit;
  fi
done

