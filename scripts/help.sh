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
basic_help() {
	echo ""
	echo "gdp - good deploy"
	echo "-----------------"
	echo "help"
	echo ""
	echo "    | | | | | | | | | | | | | | | | |"
	echo "   ###################################"
	echo "---#                                 #---"	
	echo "   #  gdp always needs an argument!  #"
	echo "---#                                 #---"	
	echo "   ###################################"
	echo "    | | | | | | | | | | | | | | | | |"
	echo " 
# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

####################################
### basic syntax ###################
####################################
#  gdp <flagX><flagY><flagZ>...<flagU>
#  example:
#    gdp dbs 
#    
#      this 'builds', 'deploys', 'starts'
#      flags can be written in any order
#      but gdp imposes a sensible order
#      of operations
#    
####################################
### configuration ##################
### c	  ##########################
####################################
#  configuration is automatically
#  prompted once for each project.
#  To reconfigure, use flag.
####################################

####################################
## deployment ######################
####################################
#
# d
# dev mode 
#   does: cp diff to nodes
# p
# prod mode
#   does: run git pull on node
#
# b build
#   does: runs configured build command 
#
####################################

####################################
### control ########################
####################################
#
# start s 
#   does: runs configured start command
#
# stop t (terminate) 
#   does: sends interupt to started process
#
# restart r
#   does: t then s
#
# switch w  #TODO in future versions
#   (for advanced CI)
#
####################################"
	echo ""
}
# list basic instructions h
if [ ! -z "$hFlag" ]; then
	basic_help
fi	
exit 0
