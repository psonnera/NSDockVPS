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

echo -e "\x1b[37;44mNightscout Docker VPS configuration                                                       \x1b[0m"

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
  CHOICE_HEIGHT=10
  BACKTITLE="Nightscout Docker VPS Management"
  TITLE="Nightscout Management"
  MENU="Use up/down arrows to select:"
  OPTIONS=(1 "View Nightscout Status"
		 2 "Update Scripts"
		 3 "Change DNS name"
		 4 "Update Nightscout"
		 5 "Edit Variables"
		 6 "Import Data"
		 7 "Restart Nightscout"
         8 "Exit to command prompt"
		 9 "Reboot Server"
		 0 "Advanced menu")

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
        git pull
		sudo chmod 775 *.sh
		clear
        echo -e "\x1b[37;44mEnter menu or ./menu.sh to return to the menu                                                     \x1b[0m"
	    prompt=1
        exit
        ;;
      3) # DNS name
        cd /nightscout/NSDockVPS
	    read oldname < /nightscout/config_dns.txt
		sudo rm /nightscout/config_dns.txt
	    sudo ./dnsname.sh
		read dnsname < /nightscout/config_dns.txt
		sudo sed -i "s/$oldname/$dnsname/" /nightscout/docker-compose.yml
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
      6) # Import Data
	    sudo ./import.sh
        ;;
      7) # Restart Nightscout
        sudo ./restart.sh
        ;;
      8) # Exit to prompt
		clear
        echo -e "\x1b[37;44mEnter menu of ./menu.sh to return to the menu                                                     \x1b[0m"
	    prompt=1
        exit
        ;;
      9) # Reboot VPS
	    sudo reboot
        ;;
  esac
done
