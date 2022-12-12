#!/bin/bash
######################################################################################################
#
#  Initial configuration
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mInitial configuration for Docker compose deploy.                                                  \x1b[0m"

# might need rework as it's absolutely not foolproof

BACKTITLE="Nightscout Docker VPS Setup"

# DDNS URL name configuration

if [ ! -f config_dns.txt ] # DDNS configuration undefined
  then
  sudo ./dnsname.sh
fi

read dnsname < config_dns.txt
if [  "`grep "$dnsname" ../docker-compose.yml`" = "" ] # Let's update the URL
  then
  sudo sed -i "s/YOUR_PUBLIC_HOST_URL/$dnsname/" ../docker-compose.yml 
fi

# TIMEZONE configuration

if [  "`grep "YOUR_TIMEZONE" ../docker-compose.yml`" != "" ] # Let's update the time zone
  then
  tzone=`./timezone.sh`
  sudo sed -i "s%YOUR_TIMEZONE%$tzone%" ../docker-compose.yml 
fi

# email configuration for traefik

if [  "`grep "YOUR_EMAIL" ../docker-compose.yml`" != "" ]
then
  emailname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm email" --title "Email setup" \
       --inputbox "Traefic needs your email for urgent notifications.\nEnter it below." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_EMAIL/$emailname/" ../docker-compose.yml
fi

# CORE variables configuration

if [  "`grep "YOUR_API_SECRET" ../docker-compose.yml`" != "" ]
then
  apisecret=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm API_SECRET" --title "Setup your API_SECRET" \
       --inputbox "This is the password to enter your Nightscout site and settings.\nIt must be at least 12 characters long.\nUse only letters and numbers, no spaces." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_API_SECRET/$apisecret/" ../docker-compose.yml
fi

# Let's build the pack!

sudo cp ../docker-compose.yml /nightscout/cgm-remote-monitor
cd /nightscout/cgm-remote-monitor
nohup sudo docker compose up &>/dev/null &	# run it in background
cd /nightscout/NSDockVPS

dialog --msgbox "Wait 5 minutes for Nightscout to start." 6 40


