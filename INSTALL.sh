#!/bin/sh 
########################################################################
# <INSTALL.sh, Install script for mmwireless project
# Copyright (C) 2014  Manuel Moscoso Dominguez manuel.moscoso.d@gmail.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
########################################################################
SCRIPT_USER=root
SCRIPT_NAME="INSTALL.sh"
SCRIPT_LOCATION=/usr/local/bin/
SOFTWARE_NAME=mmwireless
INITSCRIPT_NAME=mmmanager
INITSCRIPT_PATH=/etc/init.d/$INITSCRIPT_NAME
SCRIPT_PATH=$SCRIPT_LOCATION$SOFTWARE_NAME

check_user () {
	if [ $SCRIPT_USER != $USER ]
	then
		echo "This script must be run as root"
		exit 1
	fi
}

case "$1" in
	install)
		check_user
		cp src/$SOFTWARE_NAME $SCRIPT_PATH
		chmod 777 $SCRIPT_PATH
		chown root:root $SCRIPT_PATH
		cp src/$INITSCRIPT_NAME $INITSCRIPT_PATH
		chmod 777 $INITSCRIPT_PATH
		chown root:root $INITSCRIPT_PATH
		echo "Installation completed"
	;;
	check)
		check_user
		#FILE EXISTS
		if [ ! -f $SCRIPT_PATH ]; then
			echo "Script path does not exists"
		fi
		

	;;
	*)
		check_user
		echo "Usage: sh $SCRIPT_NAME {check|install}"
		exit 1
	;;
esac
exit 0 
