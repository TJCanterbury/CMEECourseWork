#!/bin/bash
# Author: Tristan Canterbury tjc19@ic.ac.uk
# Script: DotheTHing.sh
# Description: Model fitting temperature performance curve data
# Arguments: None
# Date: Nov 2020

#Generate results and Figure 1 using ID 257
python3 Mod.py '../Data/ThermRespData.csv' 257 903

#Other Figures
Rscript Seethething.R

#Report
bash CompileLaTeX.sh Temp.tex 
