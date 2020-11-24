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

k = 8.617e-5

## functions ##

TempResp = pd.read_csv('../Data/ThermRespData.csv')
#convert to kelvin and remove negaitve trait values
TempResp['ConTemp'] = 273.15+TempResp['ConTemp']

Tmp = TempResp[TempResp['ID']==110]

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
    B0 = x.OriginalTraitValue[x.ConTemp == 283.15]
    Tl = x.ConTemp[x.OriginalTraitValue == 0.5*max(x.OriginalTraitValue)]
    Th = x.ConTemp[x.OriginalTraitValue == 0.5*max(x.OriginalTraitValue)]


    params_school = Parameters()
    params_school.add('B0', value = B0, max = B0*1.5, min = B0*0.5)
    params_school.add('El', value = 0.5)
    params_school.add('Eh', value = 0.5)
    params_school.add('Tl', value = Tl, max = Tl*1.5, min = Tl *0.5)
    params_school.add('Th', value = Th, max = Th*1.5, min = Th *0.5)
    params_school.add('E', value = 1)
    return params_school

Starting_vals_school(Tmp)

#Create a Minimizer object
minner = Minimizer(residuals_school, params_school, fcn_args=(Tmp.ConTemp, Tmp.OriginalTraitValue))#Plug in the logged data.
#Perform the minimization
fit_school = minner.minimize(method = 'leastsq')
report_fit(fit_school)

result_school = Tmp.OriginalTraitValue + fit_school.residual
p.plot(Tmp.ConTemp, result_school, 'b.', markersize = 15, label = 'schoolfield')
#Get a smooth curve by plugging a time vector to the fitted logistic model
t_vec = np.linspace(min(Tmp.ConTemp),max(Tmp.ConTemp),1000)
log_N_vec = np.ones(len(t_vec))
residual_smooth_school = residuals_school(fit_school.params, t_vec, log_N_vec)
p.plot(t_vec, residual_smooth_school + log_N_vec, 'blue', linestyle = '--', linewidth = 1)
p.show()

#Write down the objective function that we want to minimize, i.e., the residuals 
def residuals_Briere(params, t, data):
    '''Fit a Breire model and subtract data'''
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    #Logistic model
    model = v['B'] * t * (t - v['t0']) * ((v['tm'] - t) ** (0.5))
    #Return residuals
    return model - data

params_Briere = Parameters()
params_Briere.add('B', value = 1)
params_Briere.add('t0', value = min(Tmp.ConTemp))
params_Briere.add('tm', value = max(Tmp.ConTemp), min = params_Briere['t0'])

#Create a Minimizer object
minner = Minimizer(residuals_Briere, params_Briere, fcn_args=(Tmp.ConTemp, Tmp.OriginalTraitValue))#Plug in the logged data.
#Perform the minimization
fit_Briere = minner.minimize(method = 'leastsq')

#SchoolField
result_school = Tmp.OriginalTraitValue + fit_school.residual
p.plot(Tmp.ConTemp, result_school, 'b.', markersize = 15, label = 'schoolfield')
#Get a smooth curve by plugging a time vector to the fitted logistic model
t_vec = np.linspace(min(Tmp.ConTemp),max(Tmp.ConTemp),1000)
log_N_vec = np.ones(len(t_vec))
residual_smooth_school = residuals_school(fit_school.params, t_vec, log_N_vec)
p.plot(t_vec, residual_smooth_school + log_N_vec, 'blue', linestyle = '--', linewidth = 1)
#Briere
result_logistic = Tmp.OriginalTraitValue + fit_Briere.residual
p.plot(Tmp.ConTemp, result_logistic, 'b.', markersize = 15, label = 'Briere')
#Get a smooth curve by plugging a time vector to the fitted logistic model
t_vec = np.linspace(min(Tmp.ConTemp),max(Tmp.ConTemp),1000)
log_N_vec = np.ones(len(t_vec))
residual_smooth_logistic = residuals_Briere(fit_Briere.params, t_vec, log_N_vec)
p.plot(t_vec, residual_smooth_logistic + log_N_vec, 'blue', linestyle = '--', linewidth = 1)
p.plot(Tmp.ConTemp, Tmp.OriginalTraitValue)
p.show()


def main(argv):
    """ Build Linear model """
    print('Check arguments')
    import ipdb; ipdb.set_trace()
    
    #read in data
    TempResp = pd.read_csv(argv[1])
    print('Check TempResp')
    import ipdb; ipdb.set_trace()
    
    #drop Na values from OriginalTraitValue
    TempResp['ConTemp'] = 273.15+TempResp['ConTemp']
    TempResp = TempResp[TempResp['OriginalTraitValue'].notna()]
    TempResp = TempResp[TempResp['ConTemp'].notna()]
    print('Recheck TempResp')
    import ipdb; ipdb.set_trace()
    
    # eg. %run CubicMod.py "../Data/ThermRespData.csv" 'Quadratic' ('a', 'b', 'c') (1, 1, 1)
    #params_linear = Define_Parameters(argv[3], argv[4])
    params_linear = Define_Parameters(["a","b","c"], [1,1,1])
    print('Check params_linear')
    import ipdb; ipdb.set_trace()

    # argv[1] = 'Line' for straight line model, 'Quadratic' for quadratic model, 'Cubic' for cubic model
    paras = Lin_Mod(TempResp, argv[2], params_linear)
    print(paras)
    
    n, bins, patches = p.hist(paras[:,4], 1000) 
    p.show()
    p.boxplot(paras[:,4])  
    p.show()
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)