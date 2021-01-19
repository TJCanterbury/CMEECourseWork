#!/bin/bash
#Author: Amisha a.bhojwani20@imperial.ac.uk
#Script: vectorize_timer.sh
#Desc: timing the vectorised and non vectorised versions of two scripts in both R and Python
#Arguments: none
#Date: Jan 2021

Rscript Vectorize1.R
Rscript Vectorize2.R
ipython3 vectorize1.py
ipython3 vectorize1.py