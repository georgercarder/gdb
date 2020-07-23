#!/bin/bash

# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

ynToAll=$1

####################################
### configuration ##################
####################################
gdp_configuration $ynToAll


# TODO READ IN CONFIG

####################################
### control ########################
####################################
#
# start
#
# stop
#
# restart
#
####################################

#TODO make programmatic

####################################
## deployment ######################
####################################
#
# options
#   (default start after build)?
#
# dev mode
#   cp diff to nodes, run build
#
# prod mode
#   run git pull on node, run build
#
####################################
