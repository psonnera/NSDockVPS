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
echo -e "\x1b[37;44;1m   Nightscout Scripted Install on Ubuntu VPS   \x1b[0m"
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
sleep 5
clear
echo -e "\x1b[37;44m                                                                                                  \x1b[0m"
echo -e "\x1b[37;44m            DISCLAIMER                                                                            \x1b[0m"
echo -e "\x1b[37;44m                                                                                                  \x1b[0m"
echo -e "\nThis scripted Nightscout deployment is provided for educational purposes only.\n"
echo -e "NEITHER THE AUTHOR NOR CONTRIBUTORS TO THE PUBLIC REPOSITORIES INVOLVED SHALL BE LIABLE FOR ANY"
echo -e "DAMAGES OR LOSSES ARISING FROM ANY USE, MISUSE, RELIANCE ON, INABILITY TO USE, INTERRUPTION,"
echo -e "SUSPENSION OR TERMINATION OF THIS NIGHTSCOUT AND ITS ENVIRONMENT, INCLUDING ANY INTERRUPTIONS"
echo -e "DUE TO SYSTEM FAILURES, NETWORK ATTACKS, OR SCHEDULED OR UNSCHEDULED MAINTENANCE OF THE VPS."
echo -e "\nPress Enter to continue and accept, press Ctrl-C or close this window if you do not agree.\n"
read dummy </dev/tty

echo -e "\x1b[37;44mLet me prepare things for you...                                                                  \x1b[0m"
echo

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
sudo apt-get -y install iputils-ping

# Now let's see what kind of VPS we're working on

# What's the free space with a bare Ubuntu install?
dskspace="$(df / | sed -n 2p | awk '{print $4}')"
if [ "$dskspace" -lt 10485760 ] # less than 10GB free
then
  echo -e "\x1b[37;44mThis is a very small VPS, no swap file and forced logs cleanup.                                   \x1b[0m"
	# If it's a small VPS we need to keep it clean
	sudo cat > /etc/cron.daily/journalctl << "EOF"
#!/bin/sh
journalctl --vacuum-size=100M
truncate /var/log/auth.log --size 100k
EOF
  else
  # Let's create a swap file if not already done
  echo -e "\x1b[37;44mCreating a swap file.                                                                             \x1b[0m"
  if [ ! -s /var/SWAP ]
    then
    sudo dd if=/dev/zero of=/var/SWAP bs=1M count=2048
    sudo chmod 600 /var/SWAP
    sudo mkswap /var/SWAP
  fi
  sudo swapon 2>/dev/null /var/SWAP
fi

# Now install Docker
echo -e "\x1b[37;44mInstalling Docker.                                                                                \x1b[0m"
sudo apt-get update
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
cd /

sudo apt-get -y install git

if [ ! -d /nightscout ] # This will be our working directory
  then
  sudo mkdir /nightscout
fi
sudo chmod 775 /nightscout
cd /nightscout

# Clone the repos locally
echo -e "\x1b[37;44mForking scripts and Nightscout.                                                                   \x1b[0m"
if [ ! -d NSDockVPS ] # copy the scripts or update them
  then
  sudo git clone https://github.com/psonnera/NSDockVPS.git
  else
  cd NSDockVPS
  sudo git reset --hard
  sudo git pull
  cd ..
fi
sudo chmod 775 /nightscout/NSDockVPS/*.sh

if [ ! -f /nightscout/docker-compose.yml ] # DDNS configuration undefined
  then
  sudo cp /nightscout/NSDockVPS/docker-compose.ymt /nightscout/docker-compose.yml
fi

sudo printf "%s\n" "alias menu='sudo /nightscout/NSDockVPS/menu.sh'" >> ~/.bashrc

cd /nightscout/NSDockVPS
sudo chown root:root startup.sh
sudo cp -f startup.sh /etc/profile.d	# Let's make startup autostart

sleep 1
sudo /etc/profile.d/startup.sh

