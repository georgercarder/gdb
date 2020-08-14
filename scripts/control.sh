#!/bin/sh

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

pwd_=$(pwd)
gdpLogs=$pwd_/.gdp/gdp.logs
gdpConfig=$pwd_/.gdp/gdp.config
flags=$1
####################################
### control ########################
####################################
#
# start s 
#
# restart r -> (stop then start)
#
# stop t (terminate) 
#
# switch w 
#   (for advanced CI)
#
####################################
flag_search() {
	flags=$1
	token=$2
	found=$(echo $flags | grep $token)
	if [ ! -z "$found" ]; then
		echo 1
	else
		echo 0
	fi
}
s=$(flag_search $flags s)
r=$(flag_search $flags r)
t=$(flag_search $flags t)
w=$(flag_search $flags w)
anyControl=$(($s||$r||$t||$w))
if [ $anyControl -ne 1 ]; then
	exit 0
fi
config=$(cat $gdpConfig)
lenHosts=$(echo $config | jq '."hosts" | length')
if [ -z "$lenHosts" ]; then
	lenHosts=0
fi
parse_json() {
	json=$1
	key=$2
	echo $json | jq ."\"$key\"" | sed 's/"//g'
}
#start
start_cmd() {
	config=$1
	h=$2
	cmd=$3
	host=$(echo $config | jq .hosts[$h])
	pathToPrivateKey=$(parse_json "${host[@]}" pathToPrivateKey)
	userNHost=$(parse_json "${host[@]}" user@host)
	>&2 echo "    "$userNHost
	executableDir=$(parse_json "${config[@]}" executableDir)
	projectRoot=$(parse_json "${config[@]}" projectRoot)
	targetPath=$(parse_json "${host[@]}" targetPath)
	projectFolder=${projectRoot##*/}
	executablePath=$targetPath/$projectFolder/$executableDir
	startCmd=$(parse_json "${config[@]}" startCmd)
	killOld="screen -S gdp-$projectFolder -X quit"
	startNew="screen -dm gdp-$projectFolder"
	screenExec="screen -S gdp-$projectFolder -X stuff $'$startCmd\n'"
	ssh -i $pathToPrivateKey $userNHost "cd $executablePath &&"\
		" $killOld" >> $gdpLogs 2>&1
	ssh -i $pathToPrivateKey $userNHost "cd $executablePath &&"\
		" $startNew" >> $gdpLogs 2>&1
	ssh -i $pathToPrivateKey $userNHost "cd $executablePath &&"\
		" $screenExec" #>> $gdpLogs 2>&1
	ext=$?
	if [ $ext -ne 0 ]; then
		if [ -z "$userNHost" ]; then
			>&2 echo "  $cmd failure. gdp config error" 
		else
			>&2 echo "  $cmd failure for" $userNHost
		fi
	fi
}
if [ $s -eq 1 ]; then
	>&2 echo "  running start ..." #TODO SILENT
	for (( i=0; i<$lenHosts; i++ )) 
	do
		start_cmd "${config[@]}"  $i "start" &
	done
	wait
	>&2 echo "  start complete"
	exit 0 
	#to prevent from doing excessive control calls below
fi
#restart
if [ $r -eq 1 ]; then
	>&2 echo "  running restart ..." #TODO SILENT
	for (( i=0; i<$lenHosts; i++ )) 
	do
		start_cmd "${config[@]}"  $i "restart" &
	done
	wait
	>&2 echo "  restart complete"
	exit 0
	#to prevent from doing excessive control calls below
fi
#stop
stop_cmd() {
	config=$1
	h=$2
	host=$(echo $config | jq .hosts[$h])
	pathToPrivateKey=$(parse_json "${host[@]}" pathToPrivateKey)
	userNHost=$(parse_json "${host[@]}" user@host)
	>&2 echo "    "$userNHost
	projectRoot=$(parse_json "${config[@]}" projectRoot)
	projectFolder=${projectRoot##*/}
	killOld="screen -S gdp-$projectFolder -X quit"
	ssh -i $pathToPrivateKey $userNHost " $killOld" >> $gdpLogs 2>&1
	ext=$?
	if [ $ext -ne 0 ]; then
		if [ -z "$userNHost" ]; then
			>&2 echo "  stop failure. gdp config error" 
		else
			>&2 echo "  stop failure for" $userNHost
		fi
	fi
}
if [ $t -eq 1 ]; then
	>&2 echo "  running stop ..." #TODO SILENT
	for (( i=0; i<$lenHosts; i++ )) 
	do
		stop_cmd "${config[@]}"  $i &
	done
	wait
	>&2 echo "  stop complete"
	exit 0
	#to prevent from doing excessive control calls below
fi	
#switch
if [ $w -eq 1 ]; then
	#TODO switch
	echo "switch"
	exit 0
fi

