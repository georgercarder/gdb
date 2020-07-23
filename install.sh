#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

# outlining

# check for ssh installed
# example
# ssh -V
# echo $?  (0 if installed, else nonzero)

# check for rsync installed
# rsync -V
# echo $? (0 if installed, else nonzero)

# then do same as gfmt
ln scripts/gdp.sh /usr/bin/gdp
errFlag=$(($errFlag||$?))
if [ ! $errFlag -eq 0 ]; then
	echo ""
	echo "installation unsuccessful."
	#echo "TODO SUGGESTIONS"
	exit 1
fi
echo "installation complete."
echo ""
echo "use: run 'gdp' for instructions."
