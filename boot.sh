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
echo
sleep 5
clear
echo -e "\x1b[37;44m                                                                                                  \x1b[0m"
echo -e "\x1b[37;44m            DISCLAIMER                                                                            \x1b[0m"
echo -e "\x1b[37;44m                                                                                                  \x1b[0m"
echo -e "\nThis scripted Nightscout deployment is provided for educational purposes only.\n"
echo -e "NEITHER THE AUTHOR NOR CONTRIBUTORS TO THE PUBLIC REPOSITORIES INVOLVED SHALL BE LIABLE FOR ANY DAMAGES\n OR LOSSES ARISING\
 FROM ANY USE, MISUSE, RELIANCE ON, INABILITY TO USE, INTERRUPTION, SUSPENSION OR TERMINATION\nOF THIS NIGHTSCOUT AND ITS ENVIRONMENT,\
 INCLUDING ANY INTERRUPTIONS DUE TO SYSTEM FAILURES, NETWORK ATTACKS,\nOR SCHEDULED OR UNSCHEDULED MAINTENANCE OF THE VPS."
echo -e "\nPress Enter to continue and accept, press Ctrl-C or close this window if you do not agree.\n"
read dummy </dev/tty

echo -e "\x1b[37;44mLet me prepare things for you...                                                                  \x1b[0m"
echo

sudo apt-get update

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

sudo apt-get -y install screen
sudo cat > /etc/profile.d/resume.sh << "EOF"
#!/bin/sh
sudo screen -r boot
EOF
sudo chmod +x /etc/profile.d/resume.sh
sudo screen -S boot	-X exec ./boot2.sh	# some scripts are long, we are at risk of terminal timeout, screen should allow to recover...

