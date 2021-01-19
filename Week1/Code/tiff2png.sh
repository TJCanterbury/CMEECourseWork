#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: tiff2png.sh
# Desc: Converts tif to png
# Arguments: 1 .tif file
# Date: Oct 2020

if [ $# -ne 1 ]
  then
    echo "No or too many arguments supplied, try again with 1 file you wish converted"
    exit
fi

if [ ${1: -4} != ".tif" ]
  then
     read -p "$1 is not labelled as a .tif file, try and continue anyway? (Yy/Nn)"
     if [[ $REPLY =~ ^[Nn]$ ]]
       then
         exit
     fi
fi

for f in *.tiff;
	do
		echo "Converting $f";
		convert "$f" "$(basename "$f$ .tif).png";
	done
