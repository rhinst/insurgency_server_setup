#!/bin/bash

set -e

GAMEDIR="/games"
USERACCT=ubuntu
INSTALLDIR="/home/ubuntu"

echo "Updating package list..."
apt-get -y update

echo "Installing required packages..."
apt-get -y install lib32z1 lib32ncurses5 screen vim expect

echo "Installing more required packages..."
apt-get -y install lib32stdc++6 lib32gcc1

echo "Creating $GAMEDIR directory..."
mkdir -p "$GAMEDIR"

echo "Updating permissions on $GAMEDIR..."
chown $USERACCT /games

echo "Downloading Steam for Linux archive into $INSTALLDIR..>"
cd "$INSTALLDIR"
/usr/bin/wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
echo "Extracting Steam installation files into $GAMEDIR..."
/bin/tar xvfz "$INSTALDIR/steamcmd_linux.tar.gz"
echo "Updating Steam installer permissions..."
chown $USERACCT steamcmd.sh
chmod +x steamcmd.sh

echo "Updating Steam file..."
su - $USERACCT -c "$INSTALLDIR/steamcmd.sh +runscript steam_update.txt"

IP=$(ip add show eth0| grep "inet " | sed 's/.*inet \([[:digit:]]\+\)\.\([[:digit:]]\+\)\.\([[:digit:]]\+\)\.\([[:digit:]]\+\)\/.*/\1.\2\.\3.\4/')
echo "Public IP address is $IP"

echo "Generating game launch script..."
cd "$GAMEDIR"
echo "export LD_LIBRARY_PATH=/games/insurgency/bin:${LD_LIBRARY_PATH}" > start.sh
echo "cd $GAMEDIR/insurgency" >> start.sh
echo "./srcds_linux -console +map ministry +maxplayers 24 -ip $IP -port 27015" >> start.sh
chown $USERACCT start.sh
chmod +x start.sh

echo "Generating game installer script..."
cd "$GAMEDIR"
echo "login" > install.sh
echo "force_install_dir $GAMEDIR/" >> install.sh
echo "app_update 740 validate" >> install.sh
echo "quit" >> install.sh


echo "NEXT STEPS: Run the following command as the $USERACCT user:"
echo
echo "$INSTALLDIR/steamcmd.sh +runscript $GAMEDIR/install.sh"
echo
echo "THEN: To start the server, run this command as the $USERACCT user:"
echo
echo "$GAMEDIR/start.sh"
echo
