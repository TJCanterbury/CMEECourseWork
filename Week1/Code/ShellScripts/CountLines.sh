#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: CountLines.sh
# Desc: tells you the line count of a given file
# Arguments: a file you weant the line count of
# Date: Oct 2020

# Instructions: provide file for count

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo
