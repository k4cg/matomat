#!/bin/sh
#
# Use this in /etc/inittab to startup the script on the first TTY:
# 1:2345:respawn:/sbin/getty -l /usr/bin/matomat-init.sh -n 38400 tty1
#
setterm -foreground yellow
/var/matomat/matomat.pl
