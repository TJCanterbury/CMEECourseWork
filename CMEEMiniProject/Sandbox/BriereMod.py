#!/usr/bin/env python3

""" Build a Briere model """

__appname__ = 'BriereMod.py'
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
## functions ##
#Write down the objective function that we want to minimize, i.e., the residuals 
def residuals_Briere(params, t, data):
    '''Fit a Breire model and subtract data'''
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    #Logistic model
    model = v['B'] * t * (t - v['t0']) * ((v['tm'] - t) ** (0.5))
    #Return residuals
    return model - data


def main(argv):
    """ Build Linear model and prints parameter estimates and AIC """

    TempResp = pd.read_csv(argv[1])
    TempResp['ConTemp'] = 273.15+TempResp['ConTemp']
    Tmp = TempResp[TempResp['ID']== int(argv[2])]
    Tmp = Tmp.reset_index(drop=True)
    #read in data
    params_Briere = Parameters()
    params_Briere.add('B', value = 1)
    params_Briere.add('t0', value = min(Tmp.ConTemp))
    params_Briere.add('tm', value = max(Tmp.ConTemp), min = params_Briere['t0'])
    p.plot(Tmp.ConTemp, Tmp.OriginalTraitValue)
    
    #Create a Minimizer object
    #minner = Minimizer(residuals_Briere, params_Briere, fcn_args=(Tmp.ConTemp, Tmp.OriginalTraitValue))#Plug in the logged data.
    #Perform the minimization
    #fit_Briere = minner.minimize(method = 'leastsq')
  #  report_fit(fit_Briere)
   # result_Briere = Tmp.OriginalTraitValue + fit_Briere.residual
    #p.plot(Tmp.ConTemp, result_Briere, 'b.', markersize = 15, label = 'Breire')
  #  #Get a smooth curve by plugging a time vector to the fitted logistic model
  #  t_vec = np.linspace(min(Tmp.ConTemp),max(Tmp.ConTemp),1000)
   # log_N_vec = np.ones(len(t_vec))
    #residual_smooth_Briere = residuals_Briere(fit_Briere.params, t_vec, log_N_vec)
   # p.plot(t_vec, residual_smooth_Briere + log_N_vec, 'blue', linestyle = '--', linewidth = 1)

    p.show()
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)