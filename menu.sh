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

alias menu='sudo /nightscout/NSDockVPS/menu.sh'

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
  HEIGHT=16
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
		 6 "Import Database"
		 7 "Restart Nightscout"
         8 "Exit to command prompt"
		 9 "Reboot Server")

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
        ;;
      2)
	    cd /nightscout/NSDockVPS
		sudo cp config_dns.txt ..
		git reset --hard
        git pull
        sudo cp ../config_dns.txt .
		sudo chmod 775 *.sh
	    dialog --colors --msgbox " You need to restart the menu to validate changes.\n Enter \Zrmenu\Zn at the prompt to complete update." 6 60
		clear
	    prompt=1
        exit
        ;;
      3)
	    read oldname < config_dns.txt
		sudo rm config_dns.txt
	    sudo ./dnsname.sh
		read dnsname < config_dns.txt
		sudo sed -i "s/$oldname/$dnsname/" /nightscout/docker-compose.yml		
		sudo docker compose stop
        nohup sudo docker compose up &>/dev/null &	# run it in background
        cd /nightscout/NSDockVPS
		dialog --msgbox "Wait 5 minutes for Nightscout to restart." 6 40
        ;;
      4)
        ;;
      5)
        ;;
      5)
        ;;
      6)
        ;;
      7)
        cd /nightscout
		sudo docker compose stop
        nohup sudo docker compose up &>/dev/null &	# run it in background
        cd /nightscout/NSDockVPS
		dialog --msgbox "Wait 5 minutes for Nightscout to restart." 6 40
        ;;
      8)
	    dialog --colors --msgbox " Enter \Zrmenu\Zn at the prompt to return to this menu." 5 60
		clear
	    prompt=1
        exit
        ;;
      9)
	    dialog --msgbox "  - Your server will reboot now -\n Wait 5 minutes for Nightscout to restart." 6 50
	    sudo reboot
        ;;
  esac
done
