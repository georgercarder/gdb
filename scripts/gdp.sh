#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

>&2 echo "gdp"

flags=$1

gdp_help $flags
if [ $? -eq 0 ];then
	exit 1
fi

yToAll="n"
y=$(echo $flags|grep y)
if [ ! -z "$y" ]; then
	yToAll="y"
fi

####################################
### configuration ##################
####################################
gdp_configuration $yToAll $flags # c flag?

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
gdp_deployment $flags

#TODO
####################################
### control ########################
####################################
#
# start s 
#
# stop t (terminate) 
#
# restart r
#
# switch w 
#   (for advanced CI)
#
####################################
gdp_control $flags
