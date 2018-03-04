#!/bin/bash


source config.sh

if [ $# != 3 ]; then
	echo "Usage: $0 steam_useranme steam_password steamguard_code"
	exit 1
fi

TMP=$(mktemp)

chmod 644 $TMP

echo "login $1 $2 $3" > $TMP
echo "force_install_dir /games/insurgency" >> $TMP
echo "app_update 237410 validate" >> $TMP
echo "quit" >> $TMP

cd $INSTALLDIR
./steamcmd.sh +runscript $TMP
