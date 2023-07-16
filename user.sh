#!/bin/bash
######################################################################################################
#
#  New user creation
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

# Running Nightscout as root is not a good idea

echo -e "\x1b[37;44mCreazione di un nuovo utente                                                                      \x1b[0m"

username=${SUDO_USER:-$USER}
if [ $username = "root" ]
  then
  echo -e "\x1b[37;44mSei loggato come root. Non e una buona idea di eseguire Nightscout come root.                     \x1b[0m\n"
  echo -e "Se hai gia creato un utente e sei loggato come root per errore:\n - chiudi questo terminale e loggati con il tuo utente.\n\nSe non hai un utente, adesso ne creaiamo uno."
  read -p "Digita il tuo nome utente (minuscole e numeri, no spazi, ne caratteri speciali): " username </dev/tty

  while [ $username = "root" ] || [ $username = "" ]
    do
    read -p "Digita il tuo nome utente (minuscole e numeri, no spazi, ne caratteri speciali): " username </dev/tty
	echo $username
  done
  while [ "`grep $username /etc/passwd`" != "" ]
    do
    echo -e "\x1b[37;43;1mQuesto nome utente esiste gia.\x1b[0m"
    read -p "Digita il tuo nome utente (minuscole e numeri, no spazi, ne caratteri speciali): " username </dev/tty
	echo $username
  done
  sudo useradd -s /bin/bash -d /nightscout $username
  while [ -z "`grep $username /etc/passwd`" ]
    do
    echo -e "\x1b[37;43;1mNome utente invalido.\x1b[0m"
    read -p "Digita il tuo nome utente (minuscole e numeri, no spazi, ne caratteri speciali): " username </dev/tty
	echo $username
    sudo useradd -s /bin/bash -d /nightscout $username
  done
  echo -e "\x1b[37;44mInventa una password sicura per il tuo utente. Assicurati di scriverla di qualche parte.          \x1b[0m"

  while [ "`sudo passwd -S $username | grep "$username L"`" ]
    do
    sudo passwd $username  </dev/tty
  done
fi
sudo usermod -aG sudo $username  # make user sudoer

# Add user to Docker admins nd make it startup
echo -e "\x1b[37;44mAvviamento di Docker.                                                                             \x1b[0m"
sudo groupadd docker
sudo usermod -aG docker $username
sudo systemctl enable docker

sudo chown -R $username:$username /nightscout/docker-compose.yml
sudo chown -R $username:$username /nightscout/NSDockVPS
sudo rm /nightscout/NSDockVPS/config_dns.txt

# Cleanup
sudo apt autoremove

clear
cd /nightscout/NSDockVPS
#if [ ${SUDO_USER:-$USER} = "root" ]
#  then
  ipaddress=`hostname -I | head -n1 | cut -d " " -f1`
  echo
  echo -e "\x1b[37;44mEccoci qua, la prima fase e completata.                                                           \x1b[0m"
  echo -e "\x1b[37;44mUsa questo commando ogni volta che vorrai modificare il tuo VPS Nightscout. Segnatelo.            \x1b[0m"
  echo -e "\nssh $username@$ipaddress\n"
  echo -e "\x1b[37;44mFai Logout e apri un nuovo terminale con il commando sopra.                                       \x1b[0m"
  echo -e "\n\nPremi Invio per proseguire. Quindi digita logout oppure fai Ctrl-D."
  read dummy </dev/tty 
#  else
#  sudo ./menu.sh
#fi
