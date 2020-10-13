#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: CompileLaTeX.sh
# Description: compiles tex file giving you a pdf
# Arguments: 1 tex file
# Date: 8 Oct 2020

x=$1
y=${x%.tex}

pdflatex $y.tex
pdflatex $y.tex
bibtex $y
pdflatex $y.tex
pdflatex $y.tex
evince $y.pdf &

## Cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
