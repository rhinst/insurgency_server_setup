#!/bin/bash

set -e

GAMEDIR="/games"
EBS_VOLUME_SIZE=20
USERACCT=ubuntu

echo "Updating package list..."
apt-get -y update

echo "Installing required packages..."
apt-get -y install lib32z1 lib32ncurses5 screen vim expect

echo "Installing more required packages..."
apt-get -y install lib32stdc++ lib32gcc1

echo "Creating $GAMEDIR directory..."
mkdir "$GAMEDIR"

echo "Mounting EBS volume..."
DISKDEV=$(lsblk|grep 20G|cut -f1 -d" ")
if [ $DISKDEV ]; then
	echo "Disk device is /dev/$DISKDEV"
	echo "Formatting disk..."
	/sbin/mkfs -t ext4 /dev/$DISKDEV
	echo "Mounting disk at $GAMEDIR..."
	mount /dev/xvdb /games
else
	echo "EBS Volume not found"
fi

echo "Updating permissions on $GAMEDIR..."
chown $USERACCT /games

sudo su - $USERACCT

echo "Downloading Steam for Linux archive into /tmp..."
cd /tmp
/usr/bin/wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz

echo "Extracting Steam installation files into $GAMEDIR..."
cd "$GAMEDIR"
/bin/tar xvfz steamcmd_linux.tar.gz
echo "Updating Steam installer permissions..."
chmod +x steamcmd.sh

IP=$(ip add show eth0| grep "inet " | sed 's/.*inet \([[:digit:]]\+\)\.\([[:digit:]]\+\)\.\([[:digit:]]\+\)\.\([[:digit:]]\+\)\/.*/\1.\2\.\3.\4/')
echo "Public IP address is $IP"

echo "Generating game launch script..."
echo "export LD_LIBRARY_PATH=/games/insurgency/bin:${LD_LIBRARY_PATH}" > start.sh
echo "cd $GAMEDIR/insurgency" >> start.sh
echo "./srcds_linux -console +map ministry +maxplayers 24 -ip $IP -port 27015" >> start.sh
chmod +x start.sh

