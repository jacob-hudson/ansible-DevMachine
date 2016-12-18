#!/bin/bash

#install git
sudo apt-get install git

#creates a local git dir
mkdir git

#TODO:  Make this conditional for WSL Only!!  WSL Defaults to Ubuntu 14.04 LTS (at least of 2016.12.18)
#create a symlink to git for WSL
ln -s /mnt/c/Users/Jacob/git/* git/
