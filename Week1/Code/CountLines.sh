#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: CountLines.sh
# Desc: tells you the line count of a given file
# Arguments: a file you want the line count of
# Date: Oct 2020

if [ $# -ne 1 ]
  then
    echo "No or too many arguments supplied, try again with 1 file you wish the line count of"
    exit
fi

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo
