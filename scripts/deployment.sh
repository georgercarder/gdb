#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

flags=$1

####################################
## deployment ######################
####################################
#
# d
# dev mode 
#   cp diff to nodes
# p
# prod mode
#   run git pull on node
#
# b build
#   (option)
#
####################################

d=$(echo $flags | grep d)
p=$(echo $flags | grep p)
b=$(echo $flags | grep b)
mustBuild=0
if [ ! -z "$b" ]; then # build
 	mustBuild=1	
fi
atLeastOne=$mustBuild
dOrP=0
if [ ! -z "$p" ]; then
	dOrP="p"
	atLeastOne=$(($atLeastOne||1))
fi # no elif bc getting fallback below
if [ ! -z "$d" ]; then
	dOrP="d" # when ambiguous falls back to d
	atLeastOne=$(($atLeastOne||1))
fi

config=
if [ $atLeastOne -eq 1 ]; then
	#TODO Read in config to config
	echo "lets deploy!!" #TODO delete
else
	exit 0
fi
echo $atLeastOne atLeastOne
echo $dOrP dOrP

# dep or prod
if [ "$dOrP" == "d" ]; then # dev mode
	#TODO
	echo "TODO DEV MODE"
elif [ "$dOrP" == "p" ]; then # prod mode
	#TODO
	echo "TODO PROD MODE"
fi

if [ $mustBuild -eq 0 ]; then
	exit
fi

# build
#TODO
echo "BUILD TODO"
