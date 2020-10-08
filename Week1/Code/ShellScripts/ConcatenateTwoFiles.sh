#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: concatenate 2 files
# Arguments: 2 files to be concatenated
# Date: Oct 2020

# InstructionsGive 3 files, first 2 the ones you want put together, third where the 
# new file shall be formed

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3
