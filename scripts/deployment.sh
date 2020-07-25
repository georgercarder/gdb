#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

pwd_=$(pwd)
gdpLogs=$pwd_/.gdp/gdp.logs
gdpConfig=$pwd_/.gdp/gdp.config
gdpIgnore=$pwd_/.gdp/gdp.ignore
flags=$1
parse_json() {
	json=$1
	key=$2
	echo $json | jq ."\"$key\"" | sed 's/"//g'
}
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
	config=$(cat $gdpConfig)
else
	exit 0
fi

dep_dev() {
	projectRoot=$1
	config=$2
	h=$3
	host=$(echo $config | jq .hosts[$h])
	userNHost=$(parse_json "${host[@]}" user@host)
	>&2 echo "    "$userNHost
	pathToPrivateKey=$(parse_json "${host[@]}" pathToPrivateKey)
	targetPath=$(parse_json "${host[@]}" targetPath)
	rsync -avz --exclude-from=$gdpIgnore -e "ssh -i $pathToPrivateKey" \
			$projectRoot $userNHost:$targetPath \
			>> $gdpLogs 2>&1
	if [ $? -ne 0 ]; then
		if [ -z "$userNHost" ]; then
			>&2 echo "  dev deployment failure. gdp config error" 
		else
			>&2 echo "  dev deployment failure for" $userNHost
		fi
	fi
}

dep_prod() {
	projectRoot=$1
	config=$2
	h=$3
	host=$(echo $config | jq .hosts[$h])
	userNHost=$(parse_json "${host[@]}" user@host)
	>&2 echo "    "$userNHost
	pathToPrivateKey=$(parse_json "${host[@]}" pathToPrivateKey)
	targetPath=$(parse_json "${host[@]}" targetPath)
	projectFolder=${projectRoot##*/}
	gitPullPath=$targetPath/$projectFolder
	gitRepo=$(parse_json "${host[@]}" gitRepo)
	ssh -i $pathToPrivateKey $userNHost "cd $gitPullPath &&"\
		" git checkout -- . && git pull origin master" 2>> $gdpLogs
	ext=$?
	if [ $ext -ne 0 ]; then
		if [ -z "$userNHost" ]; then
			>&2 echo "  prod deployment failure. gdp config error" 
		else
			>&2 echo "  prod deployment failure for" $userNHost
		fi
	fi
}

# dep or prod
projectRoot=$(parse_json "${config[@]}" projectRoot)
lenHosts=$(echo $config | jq '."hosts" | length')
if [ -z "$lenHosts" ]; then
	lenHosts=0
fi
if [ "$dOrP" == "d" ]; then # dev mode
	>&2 echo "  dev deploying ..." #TODO SILENT
	#   cp diff to nodes
	for (( i=0; i<$lenHosts; i++ )) 
	do
		dep_dev $projectRoot "${config[@]}"  $i &
	done
	wait
	>&2 echo "  dev deployment complete"
elif [ "$dOrP" == "p" ]; then # prod mode
	>&2 echo "  prod deploying ..." #TODO SILENT
	#   run git pull on node
	sshKeyPath=$(parse_json "${config[@]}" sshKeyPath)
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
build_rem() {
	projectRoot=$1
	buildDir=$2
	buildCommand=$3
	config=$4
	h=$5
	host=$(echo $config | jq .hosts[$h])
	userNHost=$(parse_json "${host[@]}" user@host)
	>&2 echo "    "$userNHost
	pathToPrivateKey=$(parse_json "${host[@]}" pathToPrivateKey)
	targetPath=$(parse_json "${host[@]}" targetPath)	
	projectFolder=${projectRoot##*/}
	buildPath=$targetPath/$projectFolder/$buildDir
	ssh -i $pathToPrivateKey $userNHost "cd $buildPath && $buildCommand" \
		2>> $gdpLogs
	ext=$?
	if [ $ext -ne 0 ]; then
		>&2 echo "  build failure for" $userNHost
	fi
}
# build
>&2 echo "  building ..."
if [ -z $lenHosts ]; then
	lenHosts=0
fi
buildDir=$(parse_json "${config[@]}" buildDir)
buildCommand=$(parse_json "${config[@]}" buildCommand)
if [ -z "$buildDir" ]; then
	echo "buildDir config entry empty. Check" $gdpConfig
	exit 1
elif [ -z "$buildCommand" ]; then
	echo "buildCommand config entry empty. Check" $gdpConfig
	exit 1
fi
for (( i=0; i<$lenHosts; i++ )) 
do
	build_rem $projectRoot $buildDir "${buildCommand[@]}" "${config[@]}" $i &
done
wait
echo "  build complete"
