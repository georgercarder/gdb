#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

flags=$1

h=$(echo $flags | grep h)
H=$(echo $flags | grep H)

hFlag=
if [ ! -z "$H" ]; then
	hFlag="H"
fi
if [ ! -z "$h" ]; then
	hFlag="h"
fi
if [ -z $flags ]; then
	hFlag="H" # gdp should always have a flag
fi
if [ -z "$hFlag" ]; then
	# hFlag is empty
	exit 1
fi
advanced_help() {
	#TODO
	echo "gdp - good deploy"
	echo "-----------------"
	echo "advanced help"
	echo "  TODO 1"
	echo "  ..."
	echo "  ..."
}
basic_help() {
	#TODO
	echo "gdp - good deploy"
	echo "-----------------"
	echo "basic help"
	echo "  TODO 1"
	echo "  ..."
	echo "  ..."
}
# advanced instructions H
if [ "$hFlag" == "H" ]; then
	advanced_help
	exit
fi
# list basic instructions h
if [ "$hFlag" == "h" ]; then
	basic_help
fi	

exit 0
