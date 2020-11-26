#!/bin/bash
# Author: Tristan Canterbury tjc19@ic.ac.uk
# Script: DotheTHing.sh
# Description: Model fitting temperature performance curve data
# Arguments: 
# Date: Nov 2020

rm ../Results/res.csv
python3 plot1.py '../Data/ThermRespData.csv' 256 'Plot'
echo "'Schoolfield', 'Briere', 'Cubic', 'Quadratic', 'Line'" >> ../Results/res.csv

python3 plot1.py '../Data/ThermRespData.csv' 256 'Stats'


Rscript Seethething.R
rm Rplots.pdf

bash CompileLaTeX.sh Temp.tex 