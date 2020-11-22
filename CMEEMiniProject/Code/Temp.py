#!/usr/bin/env python3

"""Description of this program or application.
You can use several lines"""

__appname__ = '[application name here]'
__author__ = 'Your Name (your@email.address)'
__version__ = '0.0.1'
__license__ = "License for this code/program"

## imports ##
import sys # module to interface our program with the operating system
from lmfit import Minimizer, Parameters, report_fit
import numpy as np
import matplotlib.pylab as p
import pandas as pd

## constants ##
k = 8.617e-5 


## functions ##
#read in data
TempResp = pd.read_csv("../Data/ThermRespData.csv")
#drop Na values from OriginalTraitValue

TempResp['ConTemp'] = 273.15+TempResp['ConTemp']
#Write down the objective function that we want to minimize, i.e., the residuals 

#Create object for storing parameters
params_linear = Parameters()

#Add parameters and initial values to it
params_linear.add('a', value = 1)
params_linear.add('b', value = 1)
params_linear.add('c', value = 1)
params_linear.add('d', value = 1)

def residuals_linear(params, t, data):
    """Calculate cubic growth and subtract data"""
    
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    
    #Cubic model
    model = v['a']*t**3 + v['b']*t**2 + v['c']*t + v['d']

    return model - data     #Return residuals

#Create a Minimizer object

paras = np.zeros((max(np.unique(TempResp.ID)),4))
for i in np.unique(TempResp.ID):
    tmp = TempResp[TempResp.ID == i]
    minner = Minimizer(residuals_linear, params_linear, fcn_args=(tmp.ConTemp, np.log(tmp.OriginalTraitValue)))
    
    #Perform the minimization
    fit_linear_NLLS = minner.minimize()

    par_dict = fit_linear_NLLS.params.valuesdict().values()
    j = i-1
    #Transform these into an array
    paras[j,:] = np.array(list(par_dict))
param_means = paras.mean(axis = 0)




def main(argv):
    """ Main entry point of the program """
    print('This is a boilerplate') # NOTE: indented using two tabs or 4 spaces
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)