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

    echo -e "\n\x1b[37;40;1mNetwork status\x1b[0m\n"
    echo -e "\thttps service:\t"
    echo -e "\tDNS service:\t"

    echo -e "\x1b[37;44m\nPress Any key to exit.                                                                          \x1b[0m"
  fi
done

#read dummy </dev/tty

sudo ./menu.sh
