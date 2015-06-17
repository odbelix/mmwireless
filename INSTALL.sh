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

## DEFINITION OF SCRIPTS
SOFTWARE_SNMP=mmwirelessbashsnmp
SOFTWARE_NAME=mmwireless
SOFTWARE_IMG=mmimages

## INIT SCRIPT
INITSCRIPT_NAME=mmmanager
INITSCRIPT_PATH=/etc/init.d/$INITSCRIPT_NAME

## SCRIPT LOCATION
SCRIPT_WIRELESS=$SCRIPT_LOCATION$SOFTWARE_NAME
SCRIPT_IMG=$SCRIPT_LOCATION$SOFTWARE_IMG
SCRIPT_SNMP=$SCRIPT_LOCATION$SOFTWARE_SNMP

## CONFIGURATION
CONFIG_DIR=/etc/$SOFTWARE_NAME
CONFIG_NAME=mmwireless.cfg
CONFIG_PATH=$CONFIG_DIR/$CONFIG_NAME


## OTHER PATHS #########################################################
LOG_DIR=/var/mmwireless/logs
RRD_PATH=/var/mmwireless/rrddb
APP_PATH=/var/mmwireless/

### COLORS  FOR MESSAGES ###############################################
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # End COLOR
########################################################################

check_user () {
	if [ $SCRIPT_USER != $USER ]
	then
		echo "This script must be run as root"
		exit 1
	fi
}

case "$1" in
	remove)
		echo "${RED}Removing $SCRIPT_WIRELESS ${NC}"
		rm -rf $SCRIPT_WIRELESS
		echo "${RED}Removing $SCRIPT_IMG ${NC}"
		rm -rf $SCRIPT_IMG
		echo "${RED}Removing $SCRIPT_SNMP ${NC}"
		rm -rf $SCRIPT_SNMP
		echo "${RED}Removing $CONFIG_PATH ${NC}"
		rm -rf $CONFIG_DIR
		echo "${RED}Removing $APP_PATH ${NC}"
		rm -rf $APP_PATH
		echo "${GREEN}Files removed ${NC}"
	;;

	depends)
		check_user 
		echo "For Debian and derived distributions"
		echo "apt-get install python-rrdtool python-pymongo"
	;;
	install)
		check_user
		echo "${GREEN}Installing $SOFTWARE_NAME in $SCRIPT_WIRELESS ${NC}"
		cp src/$SOFTWARE_NAME $SCRIPT_WIRELESS
		chmod 700 $SCRIPT_WIRELESS
		chown root:root $SCRIPT_WIRELESS
		
		echo "${GREEN}Installing $SOFTWARE_IMG in $SCRIPT_IMG ${NC}"
		cp src/$SOFTWARE_IMG $SCRIPT_IMG
		chmod 700 $SCRIPT_IMG
		chown root:root $SCRIPT_IMG
		
		echo "${GREEN}Installing $SOFTWARE_SNMP in $SCRIPT_SNMP ${NC}"
		cp src/$SOFTWARE_SNMP $SCRIPT_SNMP
		chmod 700 $SCRIPT_SNMP
		chown root:root $SCRIPT_SNMP
		
		echo "${GREEN}Installing $INITSCRIPT_NAME in $INITSCRIPT_PATH ${NC}"
		cp src/$INITSCRIPT_NAME $INITSCRIPT_PATH
		chmod 700 $INITSCRIPT_PATH
		chown root:root $INITSCRIPT_PATH
		
		echo "${GREEN}Installing $CONFIG_NAME in $CONFIG_PATH ${NC}"
		if [ ! -d "$CONFIG_DIR" ]; then
			# Control will enter here if $DIRECTORY doesn't exist.
			echo "${GREEN}Creating $CONFIG_DIR  ${NC}"
			mkdir $CONFIG_DIR
		else
			echo "${YELLOW}Directory $CONFIG_DIR already exists ${NC}"
		fi
		cp etc/$CONFIG_NAME $CONFIG_PATH
		
		if [ ! -d "$APP_PATH" ]; then
			# Control will enter here if $DIRECTORY doesn't exist.
			echo "${GREEN}Creating $APP_PATH  ${NC}"
			mkdir $APP_PATH
		else
			echo "${YELLOW}Directory $APP_PATH already exists ${NC}"
		fi
		if [ ! -d "$LOG_DIR" ]; then
			# Control will enter here if $DIRECTORY doesn't exist.
			echo "${GREEN}Creating $LOG_DIR  ${NC}"
			mkdir $LOG_DIR
		else
			echo "${YELLOW}Directory $LOG_DIR already exists ${NC}"
		fi
		if [ ! -d "$RRD_PATH" ]; then
			# Control will enter here if $DIRECTORY doesn't exist.
			echo "${GREEN}Creating $RRD_PATH  ${NC}"
			mkdir $RRD_PATH
		else
			echo "${YELLOW}Directory $RRD_PATH already exists ${NC}"
		fi
		
		echo "${GREEN}Creating RRD DATABASES ${NC}"
		$SCRIPT_IMG -c
		echo "${GREEN}RRD DATABASES CREATED ${NC}"
		ls -l $RRD_PATH
		echo "Installation completed"
	;;
	check)
		check_user
		#FILE EXISTS
		echo "${YELLOW}Checking${NC}"
		## mmwirelesss
		if [ ! -f $SCRIPT_WIRELESS ]; then
			echo "${RED}$SCRIPT_WIRELESS does not exists${NC}"
		else
			echo "${GREEN}$SCRIPT_WIRELESS exists${NC}"
		fi
		## mmimages
		if [ ! -f $SCRIPT_IMG ]; then
			echo "${RED}$SCRIPT_IMG does not exists${NC}"
		else
			echo "${GREEN}$SCRIPT_IMG exists${NC}"
		fi
		## mmwirelessbashsnmp
		if [ ! -f $SCRIPT_SNMP ]; then
			echo "${RED}$SCRIPT_SNMP does not exists${NC}"
		else
			echo "${GREEN}$SCRIPT_SNMP exists${NC}"
		fi
		## mmwireless.cfg
		if [ ! -f $CONFIG_PATH ]; then
			echo "${RED}$CONFIG_PATH does not exists${NC}"
		else
			echo "${GREEN}$CONFIG_PATH exists${NC}"
		fi
		if [ ! -d "$LOG_DIR" ]; then
		echo "${RED}$LOG_DIR does not exists${NC}"
		else
			echo "${GREEN}$LOG_DIR exists${NC}"
		fi
		if [ ! -d "$RRD_PATH" ]; then
			echo "${RED}$RRD_PATH does not exists${NC}"
		else
			echo "${GREEN}$RRD_PATH exists${NC}"
		fi
		
	;;
	*)
		check_user
		echo "${YELLOW}Instructions"
		echo "Usage: sh $SCRIPT_NAME {check|install|depends|remove}"
		echo "check: For check the correct user"
		echo "install: For installations of scripts"
		echo "depends: For view depends of scripts"
		echo "remove: For detele all files"
		echo "${NC}"
		exit 1
	;;
esac
exit 0 
