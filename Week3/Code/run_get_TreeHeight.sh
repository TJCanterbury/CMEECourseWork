#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: run_get_TreeHeight.sh
# Desc: Run a script to find the tree heights of a given csv file
# Arguments: .csv file with tree angles and and horizontal distances 
# Date: Nov 2020

if [ $# -ne 1 ]
  then
    echo "No or too many arguments supplied, using test .csv file '../Data/trees.csv'"
    Rscript get_TreeHeight.R ../Data/trees.csv
    python3 get_TreeHeight.py ../Data/trees.csv
    exit
fi

if [ ${1: -4} != ".csv" ]
  then
     read -p "$1 is not labelled as a .csv file, this script was written to read .csv files, continue anyway? (Yy/Nn)"
     if [[ $REPLY =~ ^[Nn]$ ]]
       then
         exit
     fi
fi

Rscript get_TreeHeight.R $1
python3 get_TreeHeight.py $1

exit
