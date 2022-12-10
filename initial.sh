#!/bin/bash
######################################################################################################
#
#  Initial configuration
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mInitial configuration for Docker  compose deploy.                                                 \x1b[0m"

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

tzone=`./calendar.sh`
if [  "`grep "YOUR_TIMEZONE" ../docker-compose.yml`" != "" ] # Let's update the time zone
  then
  sudo sed -i "s/YOUR_TIMEZONE/$tzone/" ../docker-compose.yml 
fi

# email configuration for traefik

if [  "`grep "YOUR_EMAIL" docker-compose.yml`"
then
  BACKTITLE="Nightscout Docker VPS Setup"
  emailname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Confirm email" --title "Email setup" \
       --inputbox "Traefic needs your email for urgent notifications.\nEnter it below." 10 50 \
        3>&1 1>&2 2>&3 3>&- )
  sudo sed -i "s/YOUR_EMAIL/$emailname/" ../docker-compose.yml
fi

# CORE variables configuration

if [  "`grep "YOUR_API_SECRET" docker-compose.yml`"
then
fi


#start docker image build

