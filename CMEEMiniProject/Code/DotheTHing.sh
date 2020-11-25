#!/bin/bash
# Author: Tristan Canterbury tjc19@ic.ac.uk
# Script: Temp.sh
# Description: Model fitting Temp data
# Arguments: 
# Date: Oct 2020

python3 Modelit.py '../Data/ThermRespData.csv' 'Line'
python3 Modelit.py '../Data/ThermRespData.csv' 'Quadratic'
python3 Modelit.py '../Data/ThermRespData.csv' 'Cubic'
python3 Modelit.py '../Data/ThermRespData.csv' 'Briere'
python3 Modelit.py '../Data/ThermRespData.csv' 'Schoolfield'

Rscript Seethething.R

bash CompileLaTeX.sh Temp.tex 