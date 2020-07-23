#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

ynToAll=$1

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
####################################
### FUNCTIONS ######################
####################################
configure() {
	ynToAll=$1
	#defaults
	dirRoot=$(echo $pwd_| sed -e 's/.*\///')
	projectName=$dirRoot
	projectRoot=$pwd_
	alias_=$projectName
	numberOfHosts=0
	HOST_N_KEYPATHS=()
	defaultGitRepo=$(git remote get-url --push origin)
	gitRepo=$defaultGitRepo
	if [ "$ynToAll" == "n" ]; then
		# projectname/alias
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
			echo "  modify hosts and their privateKeys manually "\
				"later. "\
				"(See -help later)"
		fi
		for (( h=0; h<$numberOfHosts; h++ )) 
		do
			# hosts <--> privKeys
			read -p "  <user@host>$h: " host
			emptyOrWrong=0
			if [ -z "$host" ]; then
				emptyOrWrong=1
			fi
			hasAt=$(echo $host | grep @)
			if [ -z "$hasAt" ]; then
				echo "  incorrect user@host format"
				emptyOrWrong=$(($emptyOrWrong||1))
			fi
			if [ $emptyOrWrong -eq 1 ]; then
				echo "  modify user@host's and their "\
					"privateKeys "\
					"manually later. "\
					"(See -help later)"
					break
			fi
			defaultPkPath="~/.ssh/$host.pem"
			read -p "  $host pathToPrivateKey [$defaultPkPath]: " \
								pkPath
			if [ -z "$pkPath" ]; then
				pkPath=$defaultPkPath	
			fi
			host_n_keypath=(\"user@host\":\"$host\",\
					\"pathToPrivateKey\":\"$pkPath\")
			HOST_N_KEYPATHS+=({${host_n_keypath[@]}},)
			echo ${HOST_N_KEYPATHS[@]}
		done
		# git repository 
		read -p "git repository [$defaultGitRepo]: " gitRepo
		if [ -z "$gitRepo" ]; then
			gitRepo=$defaultGitRepo
		fi
	fi
	# form json and save
	pnKV=\"projectName\":\"$projectName\"
	prKV=\"projectRoot\":\"$projectRoot\"
	aKV=\"alias_\":\"$alias_\"
	hnk=${HOST_N_KEYPATHS[@]} #arr to string
	if [ ! -z "$hnk" ]; then
		hnk=${hnk::-1} #removes last comma
	fi
	hnk=\"hosts\":[$hnk]
	gKV=\"gitRepo\":\"$gitRepo\"
	json={$pnKV,$prKV,$aKV,$hnk,$gKV}
	#save "pretty" json
	echo $json | jq > $gdpConfig
	echo "configuration saved to" $pwd_/$gdpConfig
}
read_config() {
	#TODO
	a="cat"
	b="dot"
	c="bird"
}
####################################
### ROUTINE ########################
####################################
# check pwd for config
gdpConfig=".gdp.config"
if [ ! -f $gdpConfig ]; then
	if [ -z "$ynToAll" ];then
		ynToAll="n"
	fi
	echo "gdp is not configured for this project" #"TODO"
	if [ $ynToAll == "n" ]; then
		echo "press ENTER for defaults"
		read -p "configure? [y/n]: " yn
		if [ -z "$yn" ]; then 
			yn="y" 
		fi
	fi
	if [ "$yn" == "n" ]; then 
		exit 1 
	else
		configure $ynToAll
	fi
else 
	echo "else TODO"
	read_config
fi
