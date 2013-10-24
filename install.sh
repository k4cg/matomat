#!/bin/sh

####################################################
#
# Install Script for matomat Version 0.2.2 
#
####################################################

CFG_DIR=/etc/
DATA_DIR=/var/
BIN_DIR=/usr/local/bin/
LIB_DIR=/usr/lib/perl5
MATOMAT_USER="matomat"

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ -f "$CFG_DIR/matomat.cfg" ]
	then echo "[-] Matomat Config already exists."
else
	cp matomat.cfg $CFG_DIR/matomat.cfg
	echo "[+] Config file created."
fi

if [ -d "$LIB_DIR/Matomat" ]
	then echo "[-] Matomat Perl Module Directory already exists."
else
	cp -r Matomat $LIB_DIR
	echo "[+] Matomat Perl Modules created."
fi

if [ -d "$DATA_DIR/matomat" ]
        then echo "[-] Matomat Data Directory already exists."
else 
	mkdir $DATA_DIR/matomat/ 
	chown $MATOMAT_USER $DATA_DIR/matomat/
	cp CHANGELOG.md $DATA_DIR/matomat/CHANGELOG.md
	cp README.md $DATA_DIR/matomat/README.md
	cp standard.flf $DATA_DIR/matomat/standard.flf
	echo "[+] Data Directory created."

	sqlite3 $DATA_DIR/matomat/matomat.db "CREATE TABLE user (userid INTEGER PRIMARY KEY, username TEXT UNIQUE, pw_hash TEXT, pw_change INT, rfid_id INT UNIQUE, privs INT, credits INT);"
	sqlite3 $DATA_DIR/matomat/matomat.db "INSERT INTO user  (username, pw_hash, pw_change, rfid_id, privs, credits) VALUES ('admin','$whbMBT8HnaP934ck40F5NBP11ToG2obQGzrY8FXSDq5mhRJioscGkgt8EuEgMKlSXCX1GHLieT3nDWj9pW2ICGlZFBzV6AVABD5vkaGjfvBHxzaWEUGPifuUQYESfwWu1$qNqasadPwrJOUZtukd/dnM6uDyDoBq1C20Ym26SN71PgbC7Jy6xjaTX2ceZ1bN6VBujXSqdsebZrN7yU2qQGfw',0,2452309364,1,0);"
	sqlite3 $DATA_DIR/matomat/matomat.db "CREATE TABLE drinks (drinkid INTEGER PRIMARY KEY, name TEXT UNIQUE, price INT, active INT,fixed INT,t2s TEXT);"
	sqlite3 $DATA_DIR/matomat/matomat.db "CREATE TABLE plugins (name TXT UNIQUE, filename TXT UNIQUE, active INT);"
	chown $MATOMAT_USER $DATA_DIR/matomat/matomat.db
	echo "[+] Matomat.db created."
fi

if [ -f "$BIN_DIR/matomat.pl" ]
        then echo "[-] Matomat binary already exists."
else 
        cp matomat.pl $BIN_DIR/matomat.pl
        echo "[+] Matomat binary created."
fi

