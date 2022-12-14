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

alias menu="sudo /nightscout/NSDockVPS/menu.sh"

# check this is the first run or not

cd /nightscout/NSDockVPS

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
	    sudo ./status.sh
        ;;
      2) # Update scripts
	    cd /nightscout/NSDockVPS
		sudo cp config_dns.txt ..
		git reset --hard
        git pull
        sudo cp ../config_dns.txt .
		sudo chmod 775 *.sh
		clear
		alias menu="sudo /nightscout/NSDockVPS/menu.sh"
	    prompt=1
        exit
        ;;
      3) # DNS name
	    read oldname < config_dns.txt
		sudo rm config_dns.txt
	    sudo ./dnsname.sh
		read dnsname < config_dns.txt
		sudo sed -i "s/$oldname/$dnsname/" /nightscout/docker-compose.yml		
       sudo ./initial.sh
        cd /nightscout/NSDockVPS
        ;;
      4) # Update Nightscout
	    sudo docker compose pull
        sudo ./initial.sh
        ;;
      5) # Edit variables
	    dialog --colors --msgbox " Do \zCtr-O\z \zEnter\z to save and \zCtrl-X\z to exit." 5 40
	    sudo nano /nightscout/docker-compose.yml
		sudo ./initial.sh
        ;;
      6) # Import Data
        ;;
      7) # Restart Nightscout
        cd /nightscout
        sudo ./initial.sh
        cd /nightscout/NSDockVPS
        ;;
      8) # Exit to prompt
	    dialog --colors --msgbox " Enter \Zrmenu\Zn at the prompt to return to this menu." 5 60
		clear
		alias menu="sudo /nightscout/NSDockVPS/menu.sh"
	    prompt=1
        exit
        ;;
      9) # Reboot VPS
	    sudo reboot
        ;;
  esac
done
