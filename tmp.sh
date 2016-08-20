#!/bin/bash

#install git
sudo apt-get install git

#creates a local git dir
mkdir git
#create a symlink to git for WSL
ln -s /mnt/c/Users/Jacob/git/* git/
