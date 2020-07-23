#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

echo ""
echo "installing gdp ..."

# check for ssh installed
echo "  checking openssl is available ..."
ssh -V 2> /dev/null
ext=$?  #(0 if installed, else nonzero)
if [ ! $ext -eq 0 ]; then
	echo ""
	echo "installation unsuccessful"
	echo "  openssl is not available"
	echo "  check your openssl installation"
	exit 1
fi

# check for rsync installed
echo "  checking rsync is available ..."
rsync -V > /dev/null
ext=$?  #(0 if installed, else nonzero)
if [ ! $ext -eq 0 ]; then
	echo ""
	echo "installation unsuccessful"
	echo "  openssl is not available"
	echo "  check your openssl installation"
	exit 1
fi

# then do same as gfmt
ln scripts/gdp.sh /usr/bin/gdp
ext=$?
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
