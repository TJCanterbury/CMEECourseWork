#!/bin/bash

# Instructions: provide file for count

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo
