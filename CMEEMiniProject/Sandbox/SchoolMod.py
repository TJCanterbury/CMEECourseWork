#!/usr/bin/env python3

""" Build a Schoolfied model """

__appname__ = 'SchoolMod.py'
__author__ = 'Tristan JC (tjc19@ic.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system
from lmfit import Minimizer, Parameters, report_fit
import numpy as np
import matplotlib.pylab as p
import pandas as pd
import math

## constants ## 

k = 8.617e-5


## functions ##
# Schoolfield
def residuals_school(params, t, data):
    '''Fit a Breire model and subtract data'''
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    #Logistic model
    model = (v['B0'] * np.exp((-v['E']/k) * ((1/t) - (1/283.15))) ) / (1 + np.exp((v['El']/k) * ((1/v['Tl']) - (1/t))) + np.exp((v['Eh']/k) * ((1/v['Th']) - (1/t))))
    #Return residuals
    return model - data

def Starting_vals_school(x):
    """ Find starting values for Schoolfield model parameters """
    m = (x.OriginalTraitValue[1] - x.OriginalTraitValue[0])/(x.ConTemp[1] - x.ConTemp[0])
    c = x.OriginalTraitValue[0]- (abs(m) * x.ConTemp[0])
    B0 = abs(m)*283.15 + c
    mAx = max(x.OriginalTraitValue)
    Opt = float(x.ConTemp[x.OriginalTraitValue == mAx])
    y = x[x.ConTemp >= Opt]
    w = x[x.ConTemp <= Opt]
    Tl = int(w.ConTemp[w.OriginalTraitValue == min(w.OriginalTraitValue, key=lambda z:abs(z - mAx/2))])
    Th = int(y.ConTemp[y.OriginalTraitValue == min(y.OriginalTraitValue, key=lambda z:abs(z - mAx/2))])
    
    params_school = Parameters()
    params_school.add('B0', value = B0)
    params_school.add('El', value = 1)
    params_school.add('Eh', value = 1)
    params_school.add('Tl', value = Tl)
    params_school.add('Th', value = Th)
    params_school.add('E', value = 1)
    return params_school

def main(argv):
    fields = ['ID', 'ConTemp', 'OriginalTraitValue']
    #read in data
    TempResp = pd.read_csv(argv[1], usecols = fields, dtype={'ID': int, 'ConTemp': float, 'OriginalTraitValue': float})

    #convert to kelvin and remove negaitve trait values
    TempResp['ConTemp'] = 273.15+TempResp['ConTemp']


    Tmp = TempResp[TempResp['ID']==int(argv[2])]
    Tmp = Tmp.reset_index(drop=True)

    params_school = Starting_vals_school(Tmp)
    Tmp = Tmp.reset_index(drop=True)

    #Create a Minimizer object
    minner = Minimizer(residuals_school, params_school, fcn_args=(Tmp.ConTemp, Tmp.OriginalTraitValue))#Plug in the logged data.
    #Perform the minimization
    fit_school = minner.minimize(method = 'leastsq')
    report_fit(fit_school)

    result_school = Tmp.OriginalTraitValue + fit_school.residual
    p.plot(Tmp.ConTemp, result_school, 'b.', markersize = 15, label = 'schoolfield')
    #Get a smooth curve by plugging a time vector to the fitted logistic model
    t_vec = np.linspace(min(Tmp.ConTemp),max(Tmp.ConTemp),1000)
    N_vec = np.ones(len(t_vec))
    residual_smooth_school = residuals_school(fit_school.params, t_vec, N_vec)
    p.plot(t_vec, residual_smooth_school + N_vec, 'blue', linestyle = '--', linewidth = 1)
    p.plot(Tmp.ConTemp, Tmp.OriginalTraitValue)
    p.show()

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)