# gdp 

#### good deploy

##### a "good" minimalist cli devops tool

---------------------------------------


##### overview

- I'm a big fan of some of the other devops tools, but sometimes I just need
something simple and fast to bootstrap a project. I wrote `gdp` to meet
this need. Configuration is fast, the interface is simple, and the great
performance has it's basis in throroughly-vetted and trusted primitives.  

Here what typical use of `gdp` looks like:

```
# gdp pbs 
```

The above snippit triggers each member from your fleet of machines to:

-- pull from your project's git

-- build the project's executable

-- start the executable

So Simple! Enjoy!

note: So far this has been tested in only a few environments, but if you
are having issues with your setup, let me know in the "git-issues" and
I'll push an update.

##### intallation

- run `sudo ./install.sh`

##### usage

```
    | | | | | | | | | | | | | | | | |
   ###################################
---#                                 #---
   #  gdp always needs an argument!  #
---#                                 #---
   ###################################
    | | | | | | | | | | | | | | | | |
 
# Copyright (c) 2020 George Carder georgercarder@gmail.com
# GENERAL PUBLIC LICENSE Version 3, 29 June 2007
# see LICENSE at project root

####################################
### basic syntax ###################
####################################
#  gdp <flagX><flagY><flagZ>...<flagU>
#  example:
#    gdp dbs 
#    
#      this 'builds', 'deploys', 'starts'
#      flags can be written in any order
#      but gdp imposes a sensible order
#      of operations
#    
####################################
### configuration ##################
### c	  ##########################
####################################
#  configuration is automatically
#  prompted once for each project.
#  To reconfigure, use flag.
####################################

####################################
## deployment ######################
####################################
#
# d
# dev mode 
#   does: cp diff to nodes
# p
# prod mode
#   does: run git pull on node
#
# b build
#   does: runs configured build command 
#
####################################

####################################
### control ########################
####################################
#
# start s 
#   does: runs configured start command
#
# stop t (terminate) 
#   does: sends interupt to started process
#
# restart r
#   does: t then s
#
# switch w  #TODO in future versions
#   (for advanced CI)
#
####################################
```
