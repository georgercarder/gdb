#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

echo ""
echo "installing gdp ..."

err_not_installed() {
	app=$1
	echo ""
	echo "installation unsuccessful"
	echo "  $app is not available"
	echo "  check your $app installation"
}

# check for git installed
echo "  checking git is available ..."
git version > /dev/null
ext=$?  #(0 if installed, else nonzero)
if [ ! $ext -eq 0 ]; then
	err_not_installed "git"
	exit 1
fi

# check for ssh installed
echo "  checking openssl is available ..."
ssh -V 2> /dev/null
ext=$?  #(0 if installed, else nonzero)
if [ ! $ext -eq 0 ]; then
	err_not_installed "openssl"
	exit 1
fi

# check for rsync installed
echo "  checking rsync is available ..."
rsync -V > /dev/null
ext=$?  #(0 if installed, else nonzero)
if [ ! $ext -eq 0 ]; then
	err_not_installed "rsync"
	exit 1
fi

# check for jq installed
echo "  checking jq is available ..."
jq --help > /dev/null
ext=$?  #(0 if installed, else nonzeo) 
if [ ! $ext -eq 0 ]; then
	err_not_installed "jq"
	exit 1
fi

link() {
	script=$1
	name=$(echo $script | sed 's/\..*//g')
	if [ "$name" != "gdp" ]; then 
		name="gdp_"$name
	fi
	binPath=/usr/bin/$name
	if [ ! -z "$binPath" ]; then
		rm $binPath
	fi
	ln scripts/$script $binPath
}

link gdp.sh
ext=$?
link configuration.sh
ext=$(($ext||$?))
link control.sh
ext=$(($ext||$?))
link deployment.sh
ext=$(($ext||$?))
link help.sh
ext=$(($ext||$?))
if [ ! $ext -eq 0 ]; then
	echo ""
	echo "  installation unsuccessful"
	echo "  try:"
	echo "  - using sudo"
	echo "  - removing symlinks /usr/bin/gdp and try again"
	echo "  - checking system has bash"
	echo ""
	exit 1
fi
echo ""
echo "  installation complete."
echo ""
echo "  use: run 'gdp' for instructions."
echo ""
