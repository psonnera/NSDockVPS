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

cd /nightscout/NSDockVPS
ipaddress=`hostname -I | head -n1 | cut -d " " -f1`

if [ ! -f config_dns.txt ] # DDNS configuration undefined
  then
  dnsname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Test URL" --title "DNS name setup" \
       --inputbox "Create a Nightscout URL with FreeDNS or Dynu or any other DDNS service of your choice.\n\
Use the address $ipaddress \n\
Once setup type the URL below without https://\n(For example: mybg.mooo.com)" 10 100 \
        3>&1 1>&2 2>&3 3>&- )
  echo $dnsname > config_dns.txt
  sudo hostnamectl set-hostname $dnsname
fi

read dnsname < config_dns.txt
if [  "`grep "$dnsname" /nightscout/docker-compose.yml`" = "" ] # Let's update the URL
  then
  sudo sed -i "s/YOUR_PUBLIC_HOST_URL/$dnsname/" /nightscout/docker-compose.yml 
fi

# TIMEZONE configuration

if [  "`grep "YOUR_TIMEZONE" /nightscout/docker-compose.yml`" != "" ] # Let's update the time zone
  then
  tzone=`./timezone.sh`
  sudo sed -i "s%YOUR_TIMEZONE%$tzone%" /nightscout/docker-compose.yml 
fi

# email configuration for traefik

if [  "`grep "YOUR_EMAIL" /nightscout/docker-compose.yml`" != "" ]
then
  emailname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm email" --title "Email setup" \
       --inputbox "Traefic needs your email for urgent notifications.\nEnter it below." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_EMAIL/$emailname/" /nightscout/docker-compose.yml
fi

# CORE variables configuration

if [  "`grep "YOUR_API_SECRET" /nightscout/docker-compose.yml`" != "" ]
then
  apisecret=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm API_SECRET" --title "Setup your API_SECRET" \
       --inputbox "This is the password to enter your Nightscout site and settings.\nIt must be at least 12 characters long.\nUse only letters and numbers, no spaces." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_API_SECRET/$apisecret/" /nightscout/docker-compose.yml
fi

# Let's build the pack!

cd /nightscout
nohup sudo docker compose up &>/dev/null &	# run it in background
cd /nightscout/NSDockVPS

dialog --msgbox "Wait 5 minutes for Nightscout to start." 6 40


