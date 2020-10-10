#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: tabtocsv.sh
# Description: substitute tabs for csv in a file
#              Saves the output into a .csv file
# Arguments: 1 -> tab deliminated file
# Date: Oct 2020

if [ $# -ne 1 ]
  then
    echo "No or too many arguments supplied, try again with 1 file you wish converted"
    exit
fi

echo "Creating a comma deliminated version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit
