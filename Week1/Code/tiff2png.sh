#!/bin/bash

# Instructions: provide .tif file 

for f in *.tiff;
	do
		echo "Converting $f";
		convert "$f" "$(basename "$f$ .tif).jpg";
	done
