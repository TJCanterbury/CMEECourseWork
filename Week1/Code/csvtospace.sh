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
    echo "wrong number of arguments, try again with 1 file you wish converted"
    exit
fi

if [ ${1: -4} != ".csv" ]
  then
     read -p "$1 is not labelled as a .csv file, continue anyway? (Yy/Nn)"
     if [[ $REPLY =~ ^[Nn]$ ]]
       then
         exit
     fi
fi

x=${1%.csv}
y=${x##*/}
NewFile="../Results/Spaced_$y.csv"

echo "Where new file will be: $NewFile"
read -p "Would you like to specify your own file path instead? (Yy/Nn)" -n 1 -r # self explanatory

if [[ $REPLY =~ ^[Yy]$ ]]
then
     echo
     echo "Enter your desired file path (eg. '../Results/worse.txt'):"
     read NewFile

fi
echo
touch $NewFile
echo "Creating space separated values version of $1"
cat $1 | tr -s "," " " >  $NewFile
echo "Done."
echo -e "You will find your new file here: $NewFile \n"
echo -e "Here is a teaser of your new file:\n"
head $NewFile
echo
exit
