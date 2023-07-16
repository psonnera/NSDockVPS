#!/bin/bash
######################################################################################################
#
#  Status
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

while [ true ]
do
  read -t 3 -n 1
  if [ $? = 0 ]
  then
    exit ;
  else
    clear
    echo -e "\x1b[37;44mStato del sistema                                                                                 \x1b[0m"
    echo -e "\n\x1b[37;40;1mDocker containers status\x1b[0m\n"
    if [ "`docker ps | grep mongo | grep Up`" = "" ]
    then
      echo -e "\tDatabase status:\t\x1b[37;41;1mSpento\x1b[0m"
    else
      echo -e "\tDatabase status:\t\x1b[32;1mAvviato\x1b[0m"
    fi
    if [ "`docker ps | grep nightscout | grep Up`" = "" ]
    then
      echo -e "\tNightscout status:\t\x1b[37;41;1mSpento\x1b[0m"
    else
      echo -e "\tNightscout status:\t\x1b[32;1mAvviato\x1b[0m"
    fi
    if [ "`docker ps | grep traefik | grep Up`" = "" ]
    then
      echo -e "\tTraefik status:\t\t\x1b[37;41;1mSpento\x1b[0m"
    else
      echo -e "\tTraefik status:\t\t\x1b[32;1mAvviato\x1b[0m"
    fi

    read sitename < /nightscout/config_dns.txt
    ipaddress=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)
    ipping=$(ping -c 1 $sitename | grep "$sitename (" | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')

    echo -e "\n\x1b[37;40;1mNetwork status\x1b[0m\n"
    if [ ipaddress=ipping ]
    then
      echo -e "\tDNS service:\t\t\x1b[32;1mUp $ipaddress\x1b[0m"
    else
      echo -e "\tDNS service:\t\t\x1b[37;41;1mNon corrisponde: DNS:$ipping vs VPS:$ipaddress\x1b[0m"
      echo -e "\tDNS service:\t\t\x1b[37;41;1mVerifica la configurazione DNS\x1b[0m"
    fi

    echo -e "\tNightscout site $sitename status:"
    if [[ $(wget -S --spider  "http://$sitename"  2>&1 | grep 'HTTP/1.1 200 OK') ]]
	then
	  echo -e "\t\t\t\t\x1b[32;1mHTTP Avviato\x1b[0m"
    else
      echo -e "\t\t\t\x1b[37;41;1mWeb server spento.\x1b[0m"
	fi
    if [[ $(wget -S --spider  "https://$sitename"  2>&1 | grep 'HTTP/1.1 200 OK') ]]
	then
	  echo -e "\t\t\t\t\x1b[32;1mHTTPS avviato\x1b[0m"
	else
      echo -e "\t\t\t\x1b[37;41;1mHTTPS spento.\x1b[0m"
	fi
	
    echo -e "\n\x1b[37;40;1mSpazio disco\x1b[0m\n"
	df -h /

    echo -e "\x1b[37;44m\nPremi un tasto per uscire. Ctrl-C per fermare.                                                          \x1b[0m"
	sleep 1
  fi
done
