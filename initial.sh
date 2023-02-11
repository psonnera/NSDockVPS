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
#ipaddress=`hostname -I | head -n1 | cut -d " " -f1`	NOt working on GC as external IP is not reported
ipaddress==$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)

echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
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

# DB_SIZE from disk size minus 1GB

if [  "`grep "DISK_SIZE" /nightscout/docker-compose.yml`" != "" ] # Let's update the time zone
  then
  dskspace="$(df / | sed -n 2p | awk '{print $4}')"
  let dbspace=dskspace/1024-1024
  sudo sed -i "s%DISK_SIZE%$dbspace%" /nightscout/docker-compose.yml 
fi


# TIMEZONE configuration

if [  "`grep "YOUR_TIMEZONE" /nightscout/docker-compose.yml`" != "" ] # Let's update the time zone
  then
  echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
  tzone=`./timezone.sh`
  sudo sed -i "s%YOUR_TIMEZONE%$tzone%" /nightscout/docker-compose.yml 
fi

# email configuration for traefik

if [  "`grep "YOUR_EMAIL" /nightscout/docker-compose.yml`" != "" ]
then
  echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
  emailname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm email" --title "Email setup" \
       --inputbox "Traefic needs your email for urgent notifications.\nEnter it below." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_EMAIL/$emailname/" /nightscout/docker-compose.yml
fi

# CORE variables configuration

if [  "`grep "YOUR_API_SECRET" /nightscout/docker-compose.yml`" != "" ]
then
  echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
  apisecret=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm API_SECRET" --title "Setup your API_SECRET" \
       --inputbox "This is the password to enter your Nightscout site and settings.\nIt must be at least 12 characters long.\nUse only letters and numbers, no spaces." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_API_SECRET/$apisecret/" /nightscout/docker-compose.yml
fi

# Let's build the pack!

echo -e "\x1b[37;44mRestarting/rebuilding Nightscout... Please wait                                                   \x1b[0m"

cd /nightscout
nohup sudo docker compose up -d	&	# run it in background
cd /nightscout/NSDockVPS




