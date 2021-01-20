#!/bin/bash
# Author: Tristan Canterbury tjc19@ic.ac.uk
# Script: DotheTHing.sh
# Description: Model fitting temperature performance curve data
# Arguments: None
# Date: Nov 2020

#Generate figure 1 using ID 257
python3 Mod.py '../Data/ThermRespData.csv' 831

#Generate results
python3 Mod.py '../Data/ThermRespData.csv'

#Generate Other Figures
Rscript Figures.R

#Generate .tex file
R CMD BATCH Generatetex.R

#Generate report
bash CompileLaTeX.sh Report.tex 