#!/bin/bash
# Author: Tristan Canterbury tjc19@ic.ac.uk
# Script: DotheTHing.sh
# Description: Model fitting temperature performance curve data
# Arguments: None
# Date: Nov 2020

#Figure 1, ID 257
python3 Mod.py '../Data/ThermRespData.csv' 257 'Plot'

#AIC Data
python3 Mod.py '../Data/ThermRespData.csv' 903 'Stats'

#Other Figures
Rscript Seethething.R

#Report
bash CompileLaTeX.sh Temp.tex 
