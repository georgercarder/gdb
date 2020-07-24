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

dep_dev() {
	projectRoot=$1
	config=$2
	h=$3

	host=$(echo $config | jq .hosts[$h])
	userNHost=$(echo $host | jq '."user@host"' | sed 's/"//g')
	pathToPrivateKey=$(echo $host | jq '.pathToPrivateKey')
	targetPath=$(echo $host | jq '.targetPath' | sed 's/"//g')
	rsync -avz -e "ssh -i $pathToPrivateKey" \
			$projectRoot $userNHost:$targetPath \
			> /dev/null
	if [ $? -ne 0 ]; then
		ok=$(($ok||1))
		>&2 echo "  dev deployment failure for" $userNHost
	fi
}

dep_prod() {
	projectRoot=$1
	config=$2
	h=$3
	host=$(echo $config | jq .hosts[$h])
	userNHost=$(echo $host | jq '."user@host"' | sed 's/"//g')
	pathToPrivateKey=$(echo $host | jq '.pathToPrivateKey' | sed 's/"//g')
	targetPath=$(echo $host | jq '.targetPath' | sed 's/"//g')
	projectFolder=${projectRoot##*/}
	gitPullPath=$targetPath/$projectFolder
	gitRepo=$(echo $host | jq '.gitRepo' | sed 's/"//g')
	#FIXME use single gitKey
	ssh -i $pathToPrivateKey $userNHost "cd $gitPullPath && git checkout -- . && git pull origin master" 2> /dev/null
	ext=$?
	if [ $ext -ne 0 ]; then
		ok=$(($ok||1))
		>&2 echo "  prod deployment failure for" $userNHost
	fi
}

# dep or prod
projectRoot=$(echo $config | jq '."projectRoot"' | sed 's/"//g')
lenHosts=$(echo $config | jq '."hosts" | length')
if [ "$dOrP" == "d" ]; then # dev mode
	>&2 echo "  dev deploying ..." #TODO SILENT
	#   cp diff to nodes
	if [ -z "$lenHosts" ]; then
		lenHosts=0
	fi
	ok=0
	for (( i=0; i<$lenHosts; i++ )) 
	do
		dep_dev $projectRoot "${config[@]}"  $i &
	done
	wait
	>&2 echo "  dev deployment complete"
elif [ "$dOrP" == "p" ]; then # prod mode
	>&2 echo "  prod deploying ..." #TODO SILENT
	#   run git pull on node
	if [ -z "$lenHosts" ]; then
		lenHosts=0
	fi
	ok=0
	sshKeyPath=$(echo $config | jq '."sshKeyPath"')
	for (( i=0; i<$lenHosts; i++ )) 
	do
		dep_prod $projectRoot "${config[@]}" $i $sshKeyPath &
	done
	wait
	>&2 echo "  prod deployment complete"
fi

if [ $mustBuild -eq 0 ]; then
	echo "" > /dev/null
	exit
fi

# build
#TODO
echo "BUILD TODO"
