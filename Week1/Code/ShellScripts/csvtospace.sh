#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: cvstospace.sh
# Description: Shell script that takes a .csv file and converts 
#              it into a new space separated values file. You can choose whether or
#              not to specify your own file path
# Arguments:  1 -> .csv file
# Date: Oct 2020

if [ $# -ne 1 ]
  then
    echo "No or too many arguments supplied, try again with 1 file you wish converted"
    exit
fi

x="$1"
y=${x%.csv}
z=${y##*/}
NewFile="../../Results/Spaced_$z.csv"

echo "Suggested new file path: $NewFile"
read -p "Would you like to specify your own path for your new space deliminated file? (Yy/Nn)" -n 1 -r #gives you choice, self explanatory

if [[ $REPLY =~ ^[Yy]$ ]]
then
     echo
     echo "Enter your desired file path (eg. '../../Results/worse.txt'):"
     read NewFile

fi
echo
touch $NewFile
echo "Creating space separated values version of your file ' $1'"
cat $1 | tr -s "," " " >  $NewFile
echo "Done. You will find your new file in $NewFile"
echo
echo "Here is the head of your new file:"
head $NewFile
echo
exit
