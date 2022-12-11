#!/bin/bash
######################################################################################################
#
#  boot2 script
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mLet me prepare things for you...                                                                  \x1b[0m"
echo

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

cd /nightscout/NSDockVPS
sudo chown root:root startup.sh
sudo mv -f startup.sh /etc/profile.d
cd ..

sudo rm /etc/profile.d/resume.sh	# boot phase is over we don't need to recover this session

if [ ! -d cgm-remote-monitor ]
  then
  sudo git clone https://github.com/nightscout/cgm-remote-monitor.git
  else
  echo -e "\x1b[33;44;1mNightscout is already forked here... updating it.                                                 \x1b[0m"
  cd cgm-remote-monitor
  if [ "`grep "version: '3.4.1'" docker-compose.yml`" != "" ]
  then
    sudo cp docker-compose.yml .. # Backup the configuration if already present
  else
    sudo mv ../NSDockVPS/docker-compose.yml .. # or copy the project yml
  fi
  sudo git reset --hard
  sudo git pull
  cd ..
fi

sleep 1
cd /nightscout/NSDockVPS
sudo ./user.sh
