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
    echo -e "\x1b[37;44mSystem status.                                                                                    \x1b[0m"
    echo -e "\n\x1b[37;40;1mDocker containers status\x1b[0m\n"
    if [ "`docker ps | grep mongo | grep Up`" = "" ]
    then
      echo -e "\tDatabase status:\t\x1b[37;41;1mNot running\x1b[0m"
    else
      echo -e "\tDatabase status:\t\x1b[32;1mUP\x1b[0m"
    fi
    if [ "`docker ps | grep nightscout | grep Up`" = "" ]
    then
      echo -e "\tNightscout status:\t\x1b[37;41;1mNot running\x1b[0m"
    else
      echo -e "\tNightscout status:\t\x1b[32;1mUP\x1b[0m"
    fi
    if [ "`docker ps | grep traefik | grep Up`" = "" ]
    then
      echo -e "\tTraefik status:\t\t\x1b[37;41;1mNot running\x1b[0m"
    else
      echo -e "\tTraefik status:\t\t\x1b[32;1mUP\x1b[0m"
    fi

    ipaddress=$(wget -q -O - http://checkip.dyndns.org|sed s/[^0-9.]//g)
    ipping=$(ping -c 1 $dnsname | grep "$dnsname (" | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')

    echo -e "\n\x1b[37;40;1mNetwork status\x1b[0m\n"
    if [ ipaddress=ipping ]
    them
      echo -e "\tDNS service:\t\t\x1b[32;1mUp $ipaddress\x1b[0m"
    else
      echo -e "\tDNS service:\t\t\x1b[37;41;1mNot matching: DNS:$ipping vs VPS:$ipaddress\x1b[0m"
      echo -e "\tDNS service:\t\t\x1b[37;41;1mCheck your DNS configuration\x1b[0m"
    fi

    read sitename < /nightscout/config_dns.txt
    echo -e "\tNightscout site $sitename status:"
    if [[ $(wget -S --spider  "http://$sitename"  2>&1 | grep 'HTTP/1.1 200 OK') ]]
	then
	  echo "\t\t\x1b[32;1mHTTP UP\x1b[0m"
    else
      echo -e "\t\t\t\x1b[37;41;1mNightscout down.\x1b[0m"
	fi
    if [[ $(wget -S --spider  "https://$sitename"  2>&1 | grep 'HTTP/1.1 200 OK') ]]
	then
	  echo "\t\t\x1b[32;1mHTTPS UP\x1b[0m"
	else
      echo -e "\t\t\t\x1b[37;41;1mCertificate error: try another DNS name.\x1b[0m"
	fi

    echo -e "\x1b[37;44m\nPress Any key to exit.                                                                          \x1b[0m"
  fi
done

