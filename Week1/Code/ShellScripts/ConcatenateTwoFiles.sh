#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: concatenate 2 files
# Arguments: 2 files to be concatenated and one path for the new file
# Date: Oct 2020
if [ $# -ne 3 ]
  then
    echo "missing or too many arguments, try again with 2 files you wish concatenated and 1 new file path"
    exit
fi

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3
