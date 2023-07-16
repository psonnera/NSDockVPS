#!/bin/bash
######################################################################################################
#
#  DNS name check and set
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mConfigura il nome DNS.                                                                            \x1b[0m"

BACKTITLE="Nightscout Docker VPS configurazione iniziale"
#ipaddress=`hostname -I | head -n1 | cut -d " " -f1`	NOt working on GC as external IP is not reported
ipaddress=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)

cd /nightscout
read sitename < config_dns.txt
#sudo rm config_dns.txt

while [ ! -f /nightscout/config_dns.txt ]
do
  dnsname=$(\dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Test URL" --title "Impostazione del nome DNS" \
       --inputbox "Accetta questo oppure crea un nome con qualsiasi servizio DDNS.\n\
Usa l'indirizzo $ipaddress \n\
Se lo voi modificare, digitalo sotto senza https://\n(Esempio: miagli.mooo.com)" 10 100 $sitename\
        3>&1 1>&2 2>&3 3>&- )

  ipping=$(ping -c 1 $dnsname | grep "$dnsname (" | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')

  if [ $ipping = $ipaddress ]
  then
    echo $dnsname > /nightscout/config_dns.txt
  else
  dialog --clear --backtitle "$BACKTITLE" \
       --nocancel --ok-label "Riprova" --title "DNS non corrisponde" \
       --msgbox "Tuo nome DNS $dnsname e a l'IP = $ipping\n\
Questo VPS e a l'IP = $ipaddress \n\
\nVerifica la tua configurazione DNS.\
\nSe invece e tutto corretto, prova a riavviare il VPS." 8 80
  fi

done

cd /nightscout/NSDockVPS
