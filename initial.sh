#!/bin/bash
######################################################################################################
#
#  Initial configuration
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mConfigurazione iniziale per il deploy di Docker compose.                                          \x1b[0m"

# might need rework as it's absolutely not foolproof

BACKTITLE="Creazione di Nightscout Docker VPS"

# DDNS URL name configuration

cd /nightscout
#ipaddress=`hostname -I | head -n1 | cut -d " " -f1`	NOt working on GC as external IP is not reported
ipaddress==$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)

reset
#echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
if [ ! -f config_dns.txt ] # DDNS configuration undefined
  then
  echo `hostname -A | head -n1 | cut -d " " -f1` > config_dns.txt
  read dnsname < config_dns.txt
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
  reset
  echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
  tzone=`./timezone.sh`
  sudo sed -i "s%YOUR_TIMEZONE%$tzone%" /nightscout/docker-compose.yml 
fi

# email configuration for traefik

if [  "`grep "YOUR_EMAIL" /nightscout/docker-compose.yml`" != "" ]
then
  reset
  echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
  emailname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Conferma email" --title "Impostazione Email" \
       --inputbox "Traefic necessita la tua mail per le notifiche urgente.\nDigitalo sotto." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_EMAIL/$emailname/" /nightscout/docker-compose.yml
fi

# CORE variables configuration

if [  "`grep "YOUR_API_SECRET" /nightscout/docker-compose.yml`" != "" ]
then
  reset
  echo -e "\x1b[37;44mPress Enter to continue.                                                                          \x1b[0m"
  apisecret=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Conferma API_SECRET" --title "Imposta il tuo API_SECRET" \
       --inputbox "E la password per entrare nel tuo sito Nightscout.\nMinimo 12 caratteri.\nSolo lettere e numeri, no spazi." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_API_SECRET/$apisecret/" /nightscout/docker-compose.yml
fi

# Let's build the pack!

echo -e "\x1b[37;44mRiavvio/redeploy di Nightscout... Aspetta                                                         \x1b[0m"

cd /nightscout
nohup sudo docker compose up -d	&	# run it in background
cd /nightscout/NSDockVPS




