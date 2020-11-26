#!/usr/bin/env python3

""" This script defines functions for building a linear models and takes data.csv file, 
starting values and choice of linear model as arguments """

__appname__ = 'LinearMods.py'
__author__ = 'Tristan JC (tjc19@ic.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system
from lmfit import Minimizer, Parameters, report_fit
import numpy as np
import matplotlib.pylab as p
import pandas as pd
import math
from csv import writer

## constants ##
k = 8.617e-5

## functions ##
# Linear models
def residuals_cube(params, t, data):
    """Calculate cubic growth and subtract data"""
    
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    
    #Cubic model
    model = v['a']*t**3 + v['b']*t**2 + v['c']*t + v['d']

    return model - data     #Return residuals

def residuals_quad(params, t, data):
    """Calculate quadratic growth and subtract data"""
    
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    
    #Cubic model
    model = v['a']*t**2 + v['b']*t + v['c']

    return model - data     #Return residuals

def residuals_lin(params, t, data):
    """Calculate straight line growth and subtract data"""
    
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    
    #Cubic model
    model = v['a']*t + v['b']

    return model - data     #Return residuals

def Define_Parameters(labels, values):
    #Create object for storing parameters
    par_linear = Parameters()

    for i in range(len(labels)):
        #Add parameters and initial values to it
        par_linear.add( labels[i], value = values[i])
    return par_linear

#Briere Model
def residuals_Briere(params, t, data):
    '''Fit a Breire model and subtract data'''
    #Get an ordered dictionary of parameter values
    v = params.valuesdict()
    #Logistic model
    model = v['B'] * t * (t - v['t0']) * ((v['tm'] - t) ** (0.5))
    #Return residuals
    return model - data

# Schoolfield model
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
    params_school.add('B0', value = B0, max = 10000000, min = -10000000)
    params_school.add('El', value = 1, max = 10000000, min = -10000000)
    params_school.add('Eh', value = 1, max = 10000000, min = -10000000)
    params_school.add('Tl', value = Tl, max = 10000000, min = -10000000)
    params_school.add('Th', value = Th, max = 10000000, min = -10000000)
    params_school.add('E', value = 1, max = 10000000, min = -10000000)
    return params_school

def starting_vals_Briere(x):
    """ find startting vaslues for Briere parameters """
    params = Parameters()
    params.add('B', value = 1)
    params.add('t0', value = min(x.ConTemp))
    params.add('tm', value = max(x.ConTemp))
    return params

# Model builder
def Lin_Mod(Data, ID, plot):
    """ Outputs parameter estimates and AIC for a given model and starting values """
    Type = ['Briere', 'Schoolfield', 'Line', 'Quadratic', 'Cubic']
    Colour = ['green', 'purple', 'grey', 'red', 'orange']
    tmp = Data[Data.ID == ID]
    tmp = tmp.reset_index(drop=True)
    
    Scores = np.zeros(5)

    if min(tmp.OriginalTraitValue) < 0 :
        tmp.OriginalTraitValue = tmp.OriginalTraitValue + abs(min(tmp.OriginalTraitValue))

    tmp['ConTemp'] = 273.15+tmp['ConTemp']

    #tmp['OriginalTraitValue'] = np.log(tmp['OriginalTraitValue'])

    if plot == 'Plot':
        p.plot(tmp.ConTemp, tmp.OriginalTraitValue, 'bo')

    for i in Type :
        if i == 'Schoolfield':
            colour = Colour[1]
            resid = residuals_school
            if len(tmp) < 6 :
                break
            params = Starting_vals_school(tmp)
            j = 0
        
        if i == 'Briere':
            colour = Colour[0]
            resid = residuals_Briere
            params = starting_vals_Briere(tmp)
            j = 1
        
        if i == 'Line':
            colour = Colour[2]
            resid = residuals_lin
            params = Define_Parameters(['a','b'], [1, 1])
            j = 4
        
        if i == 'Quadratic':
            colour = Colour[3]
            resid = residuals_quad 
            params = Define_Parameters(['a','b','c'], [1,1,1])
            j = 3
        
        if i == 'Cubic':
            colour = Colour[4]
            resid = residuals_cube
            params = Define_Parameters(['a','b','c','d'], [1,1,1,1])
            j = 2
            
        tmp = tmp.reset_index(drop=True)
        
        #create minimzer object
        minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, tmp.OriginalTraitValue))
                    
        #Perform the minimization
        fit_Mod = minner.minimize(method = 'leastsq')
        Scores[j] = fit_Mod.aic
        
        if plot == 'Plot':        # Plot this model type
            result = tmp.OriginalTraitValue + fit_Mod.residual
            t_vec = np.linspace(min(tmp.ConTemp),max(tmp.ConTemp),1000)
            N_vec = np.ones(len(t_vec))
            residual_smooth = resid(fit_Mod.params, t_vec, N_vec)
            predictedVal = residual_smooth + N_vec
            p.plot(t_vec, predictedVal, colour, linestyle = '--', linewidth = 1)
    if plot == 'Plot':  
        p.savefig('../Results/plot110.pdf')
        p.close()
    return(Scores)

def append_list_as_row(file_name, list_of_elem):
    # Open file in append mode
    with open(file_name, 'a+', newline='') as write_obj:
        # Create a writer object from csv module
        csv_writer = writer(write_obj)
        # Add contents of list as last row in the csv file
        csv_writer.writerow(list_of_elem)

def main(argv):
    """ Build Linear model and prints parameter estimates and AIC """
    fields = ['ID', 'ConTemp', 'OriginalTraitValue']
    #read in data
    TempResp = pd.read_csv(argv[1], usecols = fields, dtype={'ID': int, 'ConTemp': float, 'OriginalTraitValue': float}) 
    if argv[3] == 'Plot':
        Lin_Mod(TempResp, int(argv[2]), argv[3])
    if argv[3] == 'Stats':
        paras = np.zeros((906, 5))
        for i in range(1, 906):
            # For each ID attempt to fit every model, if this fails move on to next ID
            try:
                paras[i-1,:] = Lin_Mod(TempResp, i, argv[3])

                print("ID: ", i, " AIC scores ", paras[i-1,:], end="\r")
            except:
                pass
        append_list_as_row("../Results/res.csv", paras)
        print('\n')
        

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)