#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

ynToAll=$1 #TODO

####################################
### configuration ##################
####################################
#
# projectname/alias
#
# project root (fs path)
#
# hosts <--> privKeys
#
# git repository 
#
####################################
## table of contents ###############
## - globalvariables
## - functions
## - routine
####################################
### GLOBALVARIABLES ################
####################################
pwd_=$(pwd)
a="arrow"
b=""
c=""
####################################
### FUNCTIONS ######################
####################################
save() {
	filename=$1
	data=$2
	echo $data > $filename
}
configure() {
	# projectname/alias
	dirRoot=$(echo $pwd_| sed -e 's/.*\///')
	read -p "projectName [$dirRoot]: " projectName 
	if [ -z "$projectName" ]; then #default
		projectName=$dirRoot
	fi
	# project root (fs path)
	read -p "projectRoot [$pwd_]: " projectRoot
	if [ -z "$projectRoot" ]; then #default
		projectRoot=$pwd_
	fi
	# alias
	read -p "alias [$projectName]: " alias_ 
	if [ -z "$alias_" ]; then #default
		alias_=$projectName
	fi
	# numberOfHosts
	read -p "numberOfHosts [0]: " numberOfHosts
	if [ -z "$numberOfHosts" ]; then
		numberOfHosts=0
		echo "  modify hosts and their privateKeys manually later. "\
			"(See -help later)"
	fi
	for (( h=0; h<$numberOfHosts; h++ )) 
	do
		# hosts <--> privKeys
		read -p "  host$h: " host
		if [ -z "$host" ]; then
			echo "  modify hosts and their privateKeys "\
				"manually later. "\
				"(See -help later)"
				break
		fi
		defaultPkPath="~/.ssh/$host.pem"
		#if [ ! -z ${host:0:1} ]; then
		firstChar=${host:0:1}
		if [ ! -z "${firstChar##*[!0-9]*}" ]; then
			defaultPkPath="~/.ssh/_$host.pem"
		fi
		read -p "  host$h pathToPrivateKey [$defaultPkPath]: " pkPath
		if [ -z "$pkPath" ]; then
			pkPath=$defaultPkPath	
		fi
		#TODO append to an array
	done
	#
	# git repository 

	#save $configuration > $gdpConfig
}
read_config() {
	a="cat"
	b="dot"
	c="parrot"
}
####################################
### ROUTINE ########################
####################################

##FIXME jq notes
# cat file.json | jq '."key"'
# prints value

# WORKS
#bird=$(echo '[{"cat":"dog"}]')
#echo {\"parakeet\":"$bird"}|jq



# check pwd for config
gdpConfig=".gdp.config"
if [ ! -f $gdpConfig ]; then
	echo "gdp is not configured for this project" #"TODO"
	echo "press ENTER for defaults"
	read -p "configure? [y/n]: " yn
	if [ -z "$yn" ]; then 
		yn="y" 
	fi
	if [ "$yn" == "n" ]; then 
		exit 1 
	else
		configure	
	fi
else 
	echo "else TODO"
	read_config
fi


