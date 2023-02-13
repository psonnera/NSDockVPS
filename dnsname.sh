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
#ipaddress=`hostname -I | head -n1 | cut -d " " -f1`	NOt working on GC as external IP is not reported
ipaddress=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)

cd /nightscout
read sitename < /nightscout/config_dns.txt
sudo rm config_dns.txt

while [ ! -f /nightscout/config_dns.txt ]
do

  dnsname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Test URL" --title "DNS name setup" \
       --inputbox "Create a Nightscout URL with FreeDNS or Dynu or any other DDNS service of your choice.\n\
Use the address $ipaddress \n\
Once setup type the URL below without https://\n(For example: mybg.mooo.com)" 10 100 $sitename\
        3>&1 1>&2 2>&3 3>&- )

  ipping=$(ping -c 1 $dnsname | grep "$dnsname (" | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')

  if [ $ipping = $ipaddress ]
  then
    echo $dnsname > /nightscout/config_dns.txt
  else
  dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Retry" --title "DNS name mismatch" \
       --msgbox "Your DNS name $dnsname is at IP = $ipping\n\
And this VPS is at IP = $ipaddress \n\
\nCheck your configuration in FreeDNS or Dynu (or other DDNS provider)\
\nIf everything is setup correctly, reboot your VPS and retry." 8 80
  fi

done

cd /nightscout/NSDockVPS
