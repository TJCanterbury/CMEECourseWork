#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: variables.sh
# Desc: sets a variable and adds 2 values together
# Arguments: a string and 2 numerical values
# Date: Oct 2020

# Shows the use of variables 
MyVar= 'some string'
echo 'the current value of the variable is' $MyVar
echo 'Please enter a new string'
read MyVar
echo 'the current value of the variable is' $MyVar

## Reading multiple values
echo 'Enter two numbers separated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:'
mysum=`expr $a + $b`
echo $mysum
