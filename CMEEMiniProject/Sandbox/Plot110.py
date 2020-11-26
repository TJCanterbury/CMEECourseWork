#!/usr/bin/env python3

""" This script plots each models predicted results over a smooth line, and the original data, for ID 256"""

__appname__ = 'Plot110.py'
__author__ = 'Tristan JC (tjc19@ic.ac.uk)'
__version__ = '0.0.1'

## Imports ##
import matplotlib.pylab as p
import pandas as pd

## Script ##
LR = pd.read_csv('../Results/Line.residuals.csv')
QR = pd.read_csv('../Results/Quadratic.residuals.csv')
CR = pd.read_csv('../Results/Cubic.residuals.csv')
BR = pd.read_csv('../Results/Briere.residuals.csv')
SR = pd.read_csv('../Results/Schoolfield.residuals.csv')

Tmp = pd.read_csv('../Data/ThermRespData.csv')
Tmp = Tmp[Tmp.ID == 110]
Tmp['ConTemp'] = 273.15+Tmp['ConTemp']
p.plot(LR['Temperature(K)'], LR['Modelplot'], 'grey', linestyle = '--', linewidth = 1)
p.plot(QR['Temperature(K)'], QR['Modelplot'], 'red', linestyle = '--', linewidth = 1)
p.plot(CR['Temperature(K)'], CR['Modelplot'], 'orange', linestyle = '--', linewidth = 1)
p.plot(BR['Temperature(K)'], BR['Modelplot'], 'green', linestyle = '--', linewidth = 1)
p.plot(SR['Temperature(K)'], SR['Modelplot'], 'purple', linestyle = '--', linewidth = 1)
p.plot(Tmp['ConTemp'], Tmp['OriginalTraitValue'])
p.savefig('../Results/plot256.pdf')