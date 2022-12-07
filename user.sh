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

username=$USER
if [ $username = root ]
  then
  echo -e "\x1b[37;44mYou are logged as root. It is not a good idea to run Nightscout as root.                          \x1b[0m"
  echo "Let's create a new user."
  read -p "Enter a user name (lowercase letters and numbers, no space, no special characters: " username </dev/tty

  while [ $username = root ] || [ $username = "" ]
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

  sudo passwd $username  </dev/tty
fi
sudo usermod -aG sudo $username  # make user sudoer

# Add user to Docker admins nd make it startup
echo -e "\x1b[37;44mStarting Docker.                                                                                  \x1b[0m"
sudo groupadd docker
sudo usermod -aG docker $username
sudo systemctl enable docker

# Cleanup
sudo apt autoremove

ipaddress=`hostname -I | head -n1 | cut -d " " -f1`
echo
echo -e "\x1b[37;44mHere we are, pretty much done for this first phase.                                               \x1b[0m"
echo -e "\x1b[37;44mNow I will log you log out and you will need to open a new ssh session with this command:         \x1b[0m"
echo -e "\nssh $username@$ipaddress\n"
echo -e "\x1b[37;44mUse this command every time you want to modify your Nightscout VPS.                               \x1b[0m"
echo
echo -e "Oh... forgot, answer yes to: Are you sure you want to continue connecting (yes/no/[fingerprint])?"
echo
echo "Press any key when ready."

while [ true ] ; do
  read -t 3 -n 1  </dev/tty
  if [ $? = 0 ]
    then
    exit
  fi
done

logout