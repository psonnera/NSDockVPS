#!/bin/bash
######################################################################################################
#
#  New user creation
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

# Running Nightscout as root is not a good idea

echo -e "\x1b[37;44mCreate a new user                                                                                 \x1b[0m"

username=${SUDO_USER:-$USER}
if [ $username = "root" ]
  then
  echo -e "\x1b[37;44mYou are logged as root. It is not a good idea to run Nightscout as root.                          \x1b[0m\n"
  echo -e "If you already created a user and logged in as root by mistake:\n - close this terminal and log with your user.\n\nElse let's create a new user now."
  read -p "Enter a user name (lowercase letters and numbers, no space, no special characters: " username </dev/tty

  while [ $username = "root" ] || [ $username = "" ]
    do
    read -p "Enter a user name (lowercase letters and numbers, no space, no special characters: " username </dev/tty
	echo $username
  done
  while [ "`grep $username /etc/passwd`" != "" ]
    do
    echo -e "\x1b[37;43;1mThis user name already exists.\x1b[0m"
    read -p "Enter a username (lowercase letters and numbers, no space, no special characters: " username </dev/tty
	echo $username
  done
  sudo useradd -s /bin/bash -d /nightscout $username
  while [ -z "`grep $username /etc/passwd`" ]
    do
    echo -e "\x1b[37;43;1mInvalid username.\x1b[0m"
    read -p "Enter a username (lowercase letters and numbers, no space, no special characters: " username </dev/tty
	echo $username
    sudo useradd -s /bin/bash -d /nightscout $username
  done
  echo -e "\x1b[37;44mCreate a secure password for your new user. Make sure to write it down somewhere.                 \x1b[0m"

  while [ "`sudo passwd -S $username | grep "$username L"`" ]
    do
    sudo passwd $username  </dev/tty
  done
fi
sudo usermod -aG sudo $username  # make user sudoer

# Add user to Docker admins nd make it startup
echo -e "\x1b[37;44mStarting Docker.                                                                                  \x1b[0m"
sudo groupadd docker
sudo usermod -aG docker $username
sudo systemctl enable docker

sudo chown -R $username:$username /nightscout/cgm-remote-monitor
sudo chown -R $username:$username /nightscout/NSDockVPS
sudo rm /nightscout/NSDockVPS/config_dns.txt

# Cleanup
sudo apt autoremove

cd /nightscout/NSDockVPS
if [ ${SUDO_USER:-$USER} = "root" ]
  then
  ipaddress=`hostname -I | head -n1 | cut -d " " -f1`
  echo
  echo -e "\x1b[37;44mHere we are, pretty much done for this first phase.                                               \x1b[0m"
  echo -e "\x1b[37;44mUse this command every time you want to modify your Nightscout VPS. Please write it down.         \x1b[0m"
  echo -e "\nssh $username@$ipaddress\n"
  echo -e "\x1b[37;44mLogout and open a new terminal with the command above.                                            \x1b[0m"
  echo -e "\n\nPress Enter to continue. Then type logout or Ctr-D."
  read dummy </dev/tty 
  else
  sudo ./menu.sh
fi
