#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: cvstospace.sh
# Description: hell script that takes a comma separated values and converts 
#              it into a new space separated values file. You can choose whether or
#              not to specify your own file path
# Arguments:  1 -> .csv file
# Date: Oct 2020
NewFile="../Data/worse.csv" #makes new file for output

read -p "Would you like to specify your own path for your new space deliminated file? (Yy/Nn)" -n 1 -r #gives you choice, self explanatory

if [[ $REPLY =~ ^[Yy]$ ]]
then
     echo
     echo "Enter your desired file path (eg. '../Data/worse.txt'):"
     read NewFile

fi
echo
touch $NewFile
echo "Creating worse version of your file ' $1'"
cat $1 | tr -s "," " " >  $NewFile
echo "Done. You will find your new space deliminated file in $NewFile"
echo "Here is a teaser of what it will look like:"
head $NewFile
exit
