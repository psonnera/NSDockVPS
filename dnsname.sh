#!/bin/bash
######################################################################################################
#
#  DNS name check and set
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mConfigure DNS name.                                                                               \x1b[0m"

BACKTITLE="Nightscout Docker VPS Initial configuration"
ipaddress=`hostname -I | head -n1 | cut -d " " -f1`

cd /nightscout/NSDockVPS
while [ ! -f config_dns.txt ]
do

  dnsname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Test URL" --title "DNS name setup" \
       --inputbox "Create a Nightscout URL with FreeDNS or Dynu or any other DDNS service of your choice.\n\
Use the address $ipaddress \n\
Once setup type the URL below without https://\n(For example: mybg.mooo.com)" 10 100 \
        3>&1 1>&2 2>&3 3>&- )

  ipping=$(ping -c 1 $dnsname | grep "$dnsname (" | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')

  if [ $ipping = $ipaddress ]
  then
    echo $dnsname > config_dns.txt
  else
  dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Retry" --title "DNS name mismatch" \
       --msgbox "Your DNS name $dnsname is at IP = $ipping\n\
And this VPS is at IP = $ipaddress \n\
\nCheck your configuration in FreeDNS or Dynu (or other DDNS provider)" 8 80
  fi

done

cd /nightscout/NSDockVPS
sudo ./menu.sh
