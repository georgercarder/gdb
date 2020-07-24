#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

pwd_=$(pwd)
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
	gdpConfig=$pwd_/.gdp.config
	config=$(cat $gdpConfig)
else
	exit 0
fi
# dep or prod
if [ "$dOrP" == "d" ]; then # dev mode
	#   cp diff to nodes
	projectRoot=$(echo $config | jq '."projectRoot"' | sed 's/"//g')
	lenHosts=$(echo $config | jq '."hosts" | length')
	# for loop over hosts
	for (( h=0; h<$lenHosts; h++ )) 
	do
		host=$(echo $config | jq .hosts[$h])
		userNHost=$(echo $host | jq '."user@host"' | sed 's/"//g')
		pathToPrivateKey=$(echo $host | jq '.pathToPrivateKey')
		targetPath=$(echo $host | jq '.targetPath' | sed 's/"//g')
		rsync -avz -e "ssh -i $pathToPrivateKey" \
				$projectRoot $userNHost:$targetPath

	done
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
