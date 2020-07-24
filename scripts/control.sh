#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

pwd_=$(pwd)
gdpLogs=$pwd_/.gdp/gdp.logs
gdpConfig=$pwd_/.gdp/gdp.config
flags=$1
####################################
### control ########################
####################################
#
# start s 
#
# restart r
#
# stop t (terminate) 
#
# switch w 
#   (for advanced CI)
#
####################################
flag_search() {
	flags=$1
	token=$2
	found=$(echo $flags | grep $token)
	if [ ! -z "$found" ]; then
		echo 1
	else
		echo 0
	fi
}
s=$(flag_search $flags s)
r=$(flag_search $flags r)
t=$(flag_search $flags t)
w=$(flag_search $flags w)
anyControl=$(($s||$r||$t||$w))
if [ $anyControl -ne 1 ]; then
	exit 0
fi
config=$(cat $gdpConfig)
#TODO MOD CONFIG TO HAVE cmds{START,STOP}
#start
if [ $s -eq 1 ]; then
	#TODO start
	echo "start"
	exit 0 
	#to prevent from doing excessive control calls below
fi
#restart
if [ $r -eq 1 ]; then
	#TODO restart
	echo "restart"
	exit 0
	#to prevent from doing excessive control calls below
fi
#stop
if [ $t -eq 1 ]; then
	#TODO stop	
	echo "stop"
	exit 0
	#to prevent from doing excessive control calls below
fi	
#switch
if [ $w -eq 1 ]; then
	#TODO switch
	echo "switch"
	exit 0
fi

