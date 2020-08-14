#!/bin/sh

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
	hFlag="h" # gdp should always have a flag
fi
if [ -z "$hFlag" ]; then
	# hFlag is empty
	exit 1
fi
advanced_help() {
	#TODO
	echo ""
	echo "gdp - good deploy"
	echo "-----------------"
	echo "advanced help"
	echo "" 
	echo "    | | | | | | | | | | | | | | | | |"
	echo "   ###################################"
	echo "---#                                 #---"	
	echo "   #  gdp always needs an argument!  #"
	echo "---#                                 #---"	
	echo "   ###################################"
	echo "    | | | | | | | | | | | | | | | | |"
	echo ""
	echo "  ..."
	echo "  ..."
	echo ""
	#TODO more
}
basic_help() {
	#TODO
	echo ""
	echo "gdp - good deploy"
	echo "-----------------"
	echo "basic help"
	echo ""
	echo "    | | | | | | | | | | | | | | | | |"
	echo "   ###################################"
	echo "---#                                 #---"	
	echo "   #  gdp always needs an argument!  #"
	echo "---#                                 #---"	
	echo "   ###################################"
	echo "    | | | | | | | | | | | | | | | | |"
	echo ""
	echo "  ..."
	echo "  ..."
	echo "  ..."
	echo ""
	#TODO more
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
