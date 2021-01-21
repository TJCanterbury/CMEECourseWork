# Welcome to CMEEMiniProject

## Directory Structure:

Sandbox is where all my junk code went and in the Data directory you will find files holding the Biotraits TPC data used for this project. All graphs and the report will be outputed to the Results directory.
For the Code directory I will go into more detail.

### In Code you shall find:
 
 File       | Description
 ------------- | -------------
 CMEE.bib | This simply holds my bibliography for the report.
 CompileLaTeX.sh | This will be used to compile the .tex file and so generate the report as a pdf.
 DotheTHing.sh | Runs all the programs in the correct order so that the report will be generated.
 Mod.py | This generates plot110.pdf and does all the modelling involved with this report, outputting the performance data and parameter values for the modules to res.csv
 Figures.R | Plots the remaining figures for the report (piechart.pdf, Rangeplot.pdf, Params.pdf).
 Report.Rnw | Uses R and LaTeX syntax, used for including a table using R and xtable.
 Generatetex.R | one liner for generating the Report.tex file from the Report.Rnw file.
 Report.tex | LaTeX file for writing the report up, with inclusion of the generated figures.
