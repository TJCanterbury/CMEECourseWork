#!/bin/bash
# Author: Tristan JC tjc19@ic.ac.uk
# Script: tiff2png.sh
# Desc: COnverts tiff to png
# Arguments: tiff file
# Date: Oct 2020

# Instructions: provide .tif file 

for f in *.tiff;
	do
		echo "Converting $f";
		convert "$f" "$(basename "$f$ .tif).jpg";
	done
