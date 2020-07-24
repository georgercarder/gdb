#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

yToAll=$1
flags=$2

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
gdpDir=$pwd_/.gdp
gdpConfig=$gdpDir/gdp.config
####################################
### FUNCTIONS ######################
####################################
configure() {
	echo "configuring ..."
	yToAll=$1
	#defaults
	dirRoot=$(echo $pwd_| sed -e 's/.*\///')
	projectName=$dirRoot
	projectRoot=$pwd_
	alias_=$projectName
	numberOfHosts=0
	defaultTargetPath="~/"
	HOST_N_KEYPATHS=()
	defaultGitRepo=$(git remote get-url --push origin)
	gitRepo=$defaultGitRepo
	defaultBuildDir="."
	buildDir= #relative to project root
	defaultBuildCommand="make"
	buildCommand=
	executableDir=
	startCmd=
	if [ "$yToAll" == "n" ]; then
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
			read -p "  $host targetPath [$defaultTargetPath]: "\
								targetPath
			if [ -z "$targetPath" ]; then
				targetPath=$defaultTargetPath
			fi
			host_n_keypath=(\"user@host\":\"$host\",\
					\"pathToPrivateKey\":\"$pkPath\",\
					\"targetPath\":\"$targetPath\")
			HOST_N_KEYPATHS+=({${host_n_keypath[@]}},)
		done
		# git repository 
		read -p "git repository [$defaultGitRepo]: " gitRepo
		if [ -z "$gitRepo" ]; then
			gitRepo=$defaultGitRepo
		fi
		# build dir
		read -p "build dir (relative to project root) [$defaultBuildDir]: " buildDir
		if [ -z "$buildDir" ]; then
			buildDir=$defaultBuildDir
		fi
		# build command
		read -p "build command [$defaultBuildCommand]: " buildCommand
		if [ -z "$buildCommand" ]; then
			buildCommand=$defaultBuildCommand
		fi
		# executable dir
		read -p "executable dir (relative to project root) [build dir]: " executableDir 
		if [ -z "$executableDir" ]; then
			executableDir=$defaultExecutableDir
		fi
		# start command
		read -p "startCmd []: " startCmd 
		if [ -z "$startCmd" ]; then
			startCmd=""
		fi
	fi
	# form json and save
	pnKV=\"projectName\":\"$projectName\"
	prKV=\"projectRoot\":\"$projectRoot\"
	aKV=\"alias_\":\"$alias_\"
	hnk=${HOST_N_KEYPATHS[@]} #arr to string
	if [ ! -z "$hnk" ]; then
		hnk=${hnk::-1} #removes last comma
	else
		host_n_keypath=(\"user@host\":\"\",\
				\"pathToPrivateKey\":\"\",\
				\"targetPath\":\"\")
		hnk={${host_n_keypath[@]}}
	fi
	hnk=\"hosts\":[$hnk]
	gKV=\"gitRepo\":\"$gitRepo\"
	bKV=\"buildDir\":\"$buildDir\"
	cKV=\"buildCommand\":\"$buildCommand\"
	eKV=\"executableDir\":\"$executableDir\"
	sKV=\"startCmd\":\"$startCmd\"
	json={$pnKV,$prKV,$aKV,$hnk,$gKV,$bKV,$cKV,$eKV,$sKV}
	#save "pretty" json
	echo $json | jq > $gdpConfig
	echo "configuration saved to" $gdpConfig
}
####################################
### ROUTINE ########################
####################################
# check pwd for config
mustConfigure=0
if ! test -d $gdpDir; then
	mkdir $gdpDir
fi
if ! test -f $gdpConfig; then
	mustConfigure=$(($mustConfigure||1))
elif [ ! -z $(echo $flags|grep c ) ];then
	mustConfigure=$(($mustConfigure||1))
fi
if [ $mustConfigure -eq 1 ]; then
	if [ -z "$yToAll" ];then
		yToAll="n"
	fi
	echo "configure gdp for this project" #"TODO"
	if [ $yToAll == "n" ]; then
		echo "press ENTER for defaults"
		read -p "configure? [y/n]: " yn
		if [ -z "$yn" ]; then 
			yn="y" 
		fi
	fi
	if [ "$yn" == "n" ]; then 
		echo "configuration is necessary to use gdp"
		exit 1 
	else
		configure $yToAll
	fi
fi
