#!/bin/bash
######################################################################################################
#
#  Nightscout in Docker Scripted Deployment
#
#  Paper Plane Nightscout Challenge - Candidate 0.2
#
#  Using knowledge and code from #WeAreNotWaiting people
#  In no order Jon, Navid, Tzachi, Peter, Andries, Amber
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

reset
echo -e "\x1b[37;44;1m Nightscout Scripted Install on Ubuntu VPS \x1b[0m"
echo
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣿⣷⣶⣦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣿⣿⣿⡿⠿⠛⠛⠛⠛⠛⠛⠛⠿⢿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⣀⣀⣀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠋⠀⠀⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⡀⠀⠀⠉⠻⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠋⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠘⢿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⡿⠁⠀⠀⠀⠉⠉⠉⠉⠉⠙⠻⢿⣿⣿⣿⣿⠟⠛⠉⠉⠉⠉⠉⠁⠀⠀⠈⢿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⠃⠀⠀⠀⢀⣠⡤⠤⠤⣄⡀⠀⠀⠙⠿⠋⠀⠀⢀⣠⠤⠤⠤⣄⡀⠀⠀⠀⠈⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⢠⣿⣿⡏⠀⠀⠀⡴⠋⠀⠀⠀⠀⠀⠉⢳⡀⠀⠀⠀⢀⡴⠋⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⣸⠁⠀⢀⣴⣶⣶⡄⠀⠀⢻⠀⠀⠀⡼⠀⠀⢀⣴⣶⣦⡀⠀⠀⢷⠀⠀⠀⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⢿⠀⠀⠘⣿⣿⣿⠇⠀⠀⢸⡆⠀⠀⣧⠀⠀⠸⣿⣿⣿⠇⠀⠀⣸⠀⠀⠀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⢸⣦⡀⠀⠀⠉⠁⠀⠀⣠⣿⡇⠀⠀⣿⣆⠀⠀⠈⠉⠁⠀⠀⣰⡟⠀⠀⢰⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⣿⣿⣷⠀⠀⠀⢿⣿⣦⣤⣤⣤⣴⣾⣿⣿⡇⠀⠀⣿⣿⣷⣦⣤⣤⣤⣴⣾⡿⠁⠀⠀⣸⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⡄⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣅⣀⣀⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⢀⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣷⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⣼⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣧⠀⠀⠀⠀⠀⠈⠛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀⢰⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣆⠀⠀⠰⣤⣀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⠀⠀⢀⣤⠆⠀⠀⢠⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣆⠀⠀⠘⣿⣿⣶⣦⡄⠀⠀⢀⣠⣤⣤⣴⣶⣿⣿⠏⠀⠀⣠⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣦⠀⠀⠈⢿⣿⠟⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⠋⠀⠀⣰⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣧⡀⠀⠈⠋⠀⠀⣠⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⣴⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣄⠀⠀⠀⢼⣿⣿⣿⣿⣿⣿⠏⠀⠀⢠⣾⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣦⡀⠀⠀⠻⣿⣿⣿⠟⠁⠀⢀⣴⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣆⠀⠀⠈⠻⠃⠀⠀⣠⣾⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣷⣄⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣷⣤⣾⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⠿⠿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo
echo "               Welcome to Nightscout."
echo "         Open source. Open data. Open hearts."
echo
sleep 5
echo -e "\x1b[37;44mLet me prepare things for you...                                                                  \x1b[0m"
echo

# Let's update and cleanup
sudo apt-get update

# We need 20.04 for the MongoDB issue with 22.04
echo -e "\x1b[37;44mChecking OS is Ubuntu 20.04.                                                                      \x1b[0m"
ubversion="$(cat /etc/issue | awk '{print $2}')"
if [[ ! "$ubversion" = "20.04"* ]]
  then
  echo
  echo -e "\x1b[31;40;1mThis Nightscout deployment script will only work with Ubuntu 20.04LTS x64\x1b[0m"
  echo -e "\x1b[37;41;1mNightscout install failed - wrong Ubuntu version.\x1b[0m"
  echo
  exit
fi

echo -e "\x1b[37;44mInstalling utilities.                                                                             \x1b[0m"
sudo apt-get -y install dialog
sudo apt-get -y install nano

# Let's create a swap file if not already done
#echo -e "\x1b[37;44mCreating a swap file.                                                                             \x1b[0m"
#if [ ! -s /var/SWAP ]
#  then
#  sudo dd if=/dev/zero of=/var/SWAP bs=1M count=2048
#  sudo chmod 600 /var/SWAP
#  sudo mkswap /var/SWAP
#fi
#swapon 2>/dev/null /var/SWAP

# Now install Docker
echo -e "\x1b[37;44mInstalling Docker.                                                                                \x1b[0m"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
cd /
if [ ! -s nightscout ] # This will be our working directory
  then
  sudo mkdir nightscout
fi
sudo chmod 775 /nightscout
cd nightscout

# Clone the repos locally
echo -e "\x1b[37;44mForking Nightscout.                                                                               \x1b[0m"
if [ ! -s cgm-remote-monitor ]
  then
  sudo git clone https://github.com/nightscout/cgm-remote-monitor.git
  else
  echo -e "\x1b[30;43;1mNightscout is already forked here... updating it.                                             \x1b[0m"
  cp cgm-remote-monitor/docker-compose.yml . # Backup the configuration if already present
  sudo git reset --hard
  sudo git pull
  cp docker-compose.yml cgm-remote-monitor/. # Restore
fi
if [ ! -s NSDockVPS ] # copy the scripts or update them
  then
  sudo git clone https://github.com/psonnera/NSDockVPS.git
  else
  sudo git reset --hard
  sudo git pull
fi
sudo chmod 775 NSDockVPS/*.sh
cd NSDockVPS
sudo chown root:root menu.sh
sudo mv -f menu.sh /etc/profile.d

# Running Nightscout as root is not a good idea
echo -e "\x1b[37;44mCreate a new user                                                                                 \x1b[0m"
iu=0
if [ $USER = root ]
  then
  echo -e "\x1b[37;44mYou are logged as root. It is not a good idea to run Nightscout as root.                          \x1b[0m"
  echo "Let's create a new user."
  read -p "Enter a user name (lowercase letters and numbers, no space, no special characters: " username
  while [ "`grep $username /etc/passwd`" != "" ]
    do
    echo -e "\x1b[37;43;1mThis user name already exists.\x1b[0m"
    read -p "Enter a username (lowercase letters and numbers, no space, no special characters: " username
  done
  sudo useradd $username
  while [ -z "`grep $username /etc/passwd`" ]
    do
    echo -e "\x1b[37;43;1mInvalid username.\x1b[0m"
    read -p "Enter a username (lowercase letters and numbers, no space, no special characters: " username
    sudo useradd $username
  done
  echo -e "\x1b[37;44mCreate a secure password for your new user. Make sure to write it down somewhere.                 \x1b[0m"
  sudo passwd $username
fi
sudo usermod -aG sudo $username  # make user sudoer

# Add user to Docker admins nd make it startup
echo -e "\x1b[37;44mStarting Docker.                                                                                  \x1b[0m"
sudo groupadd docker
sudo usermod -aG docker $username
sudo systemctl enable docker

# Cleanup
sudo apt autoremove

echo -e "\x1b[37;44mHere we are, pretty much done for this first phase.                                               \x1b[0m"
echo -e "\x1b[37;44mNow log out (Ctrl-D) and open a new ssh session with this command:                                \x1b[0m"
echo "ssh $username@yourserverIP"
echo -e "\x1b[37;44mReplace yourserverIP with the real VPS IP.                                                        \x1b[0m"
echo
