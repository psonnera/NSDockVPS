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

echo -e "\x1b[37;44mNightscout Docker VPS configurazione                                                              \x1b[0m"

cd /nightscout/NSDockVPS

if [ ! -f /etc/profile.d/NSVPSMenu.sh ]
  then
  sudo cat > NSVPSMenu.sh << EOF
#!/bin/bash
alias menu='/nightscout/NSDockVPS/menu.sh'
EOF
  sudo chmod 755 NSVPSMenu.sh
  sudo mv NSVPSMenu.sh /etc/profile.d/
fi

if [ ! -f /nightscout/config_dns.txt ] # DDNS configuration undefined
  then
  echo `hostname -A | head -n1 | cut -d " " -f1` > /nightscout/config_dns.txt
  read dnsname < /nightscout/config_dns.txt
  sudo hostnamectl set-hostname $dnsname
fi

# check this is the first run or not

if [ ! "`sudo docker ps -a | grep "docker"`" ] # any container running?
then
  sudo ./initial.sh
fi

username=${SUDO_USER:-$USER}
sudo chown -R $username:$username /nightscout
sudo chown -R $username:$username /nightscout/docker-compose.yml
sudo chown -R $username:$username /nightscout/NSDockVPS

prompt=0

while [ $prompt = 0 ]
do
  HEIGHT=17
  WIDTH=40
  CHOICE_HEIGHT=8
  BACKTITLE="Gestione Nightscout Docker VPS"
  TITLE="Nightscout Management"
  MENU="Usa le frecce su e giu per selezionare:"
  OPTIONS=(1 "Visualizzare lo stato"
		 2 "Aggiornare gli script"
		 3 "Cambiare il nome DNS"
		 4 "Aggiornare Nightscout"
		 5 "Editare le variabili"
		 6 "Riavviare Nightscout"
         7 "Uscire al prompt di commandi"
		 8 "Riavviare il server VPS")

  CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)
		
  clear
  case $CHOICE in
      0) # Advanced
        ;;
      1) # Status
        cd /nightscout/NSDockVPS
	    sudo ./status.sh
        ;;
      2) # Update scripts
        cd /nightscout/NSDockVPS
		git reset --hard
        git pull origin ionos_it
		sudo chmod 775 *.sh
		clear
        echo -e "\x1b[37;44mDigita menu o ./menu.sh per tornare al menu                                                       \x1b[0m"
	    prompt=1
        exit
        ;;
      3) # DNS name
        cd /nightscout/NSDockVPS
	    sudo ./dnsname.sh
		read dnsname < /nightscout/config_dns.txt
        currdns="`grep "traefik.http.routers.nightscout.rule=Host" /nightscout/docker-compose.yml`"
		newdns="      - 'traefik.http.routers.nightscout.rule=Host(\`$dnsname\`)'"
		sudo sed -i "s/$currdns/$newdns/" /nightscout/docker-compose.yml
        sudo ./restart.sh
        ;;
      4) # Update Nightscout
        cd /nightscout
	    sudo docker compose pull
        sudo ./restart.sh
        ;;
      5) # Edit variables
	    sudo ./varedit.sh
		sudo ./restart.sh
        ;;
      6) # Restart Nightscout
	    cd /nightscout
        sudo docker compose down
		nohup sudo docker compose up -d &	# run it in background
        cd /nightscout/NSDockVPS
		dialog --nook --nocancel --pause "Aspetta fino a 5 minuti\nper il riavvio di Nightscout." 7 40 10
		sudo ./status.sh
        ;;
      7) # Exit to prompt
        cd /nightscout/NSDockVPS
		clear
        echo -e "\x1b[37;44mDigita menu o ./menu.sh per tornare al menu                                                       \x1b[0m"
	    prompt=1
        exit
        ;;
      8) # Reboot VPS
	    sudo reboot
        ;;
  esac
done
