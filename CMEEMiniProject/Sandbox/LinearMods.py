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
    
    m = (x.OriginalTraitValue[1] - x.OriginalTraitValue[0])/(x.ConTemp[1] - x.ConTemp[0])
    c = x.OriginalTraitValue[0]- (m * x.ConTemp[0])
    B0 = m*283.15 + c

    Tl = (0.5*max(x.OriginalTraitValue))/m -c
    Th = Tl


    params_school = Parameters()
    params_school.add('B0', value = B0, max = B0*1.5+1, min = B0*0.5)
    params_school.add('El', value = 0.5, min = 0)
    params_school.add('Eh', value = 0.5, min = 0)
    params_school.add('Tl', value = Tl, max = Tl*1.5, min = 0)
    params_school.add('Th', value = Th, max = Th*1.5, min = 0)
    params_school.add('E', value = 1, min = 0)
    return params_school

# Model builder
def Lin_Mod(Data, Type):
    """ Outputs parameter estimates and AIC for a given model and starting values """
    if Type == 'Briere':
        paras = np.zeros((max(np.unique(Data.ID)),5))
        resid = residuals_Briere
    if Type == 'Schoolfield':
        paras = np.zeros((max(np.unique(Data.ID)),8))
        resid = residuals_school
    if Type == 'Line':
        paras = np.zeros((max(np.unique(Data.ID)),4))
        resid = residuals_lin
        params = Define_Parameters(['a','b'], [1, 1])
    if Type == 'Quadratic':
        paras = np.zeros((max(np.unique(Data.ID)),5))
        resid = residuals_quad 
        params = Define_Parameters(['a','b','c'], [1,1,1])
    if Type == 'Cubic':
        paras = np.zeros((max(np.unique(Data.ID)),6)) 
        resid = residuals_cube
        params = Define_Parameters(['a','b','c','d'], [1,1,1,1])
    for i in np.unique(Data.ID):
        try:
            #Subset data by ID
            if (len(Data[Data.ID == i]) >= 6) :
                tmp = Data[Data.ID == i]
                tmp = tmp.reset_index(drop=True)
                if Type == 'Schoolfield':
                    params = Starting_vals_school(tmp)
                if Type == 'Briere':
                    params = Parameters()
                    params.add('B', value = 1)
                    params.add('t0', value = min(tmp.ConTemp))
                    params.add('tm', value = max(tmp.ConTemp))

                #create minimzer object
                minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, (tmp.OriginalTraitValue)))
                
                #Perform the minimization
                fit_Mod = minner.minimize(method = 'leastsq')
                
                #extract parameter values
                par_dict = fit_Mod.params.valuesdict().values()
                par = np.array(list(par_dict), dtype = float)
            
                #Construct the fitted polynomial equation
                my_poly = np.poly1d(par)

                #Compute predicted values
                ypred = my_poly(tmp.ConTemp)

                #Calculate residuals
                residuals = ypred - tmp.OriginalTraitValue
                
                #calculate R squared
                RSS = sum(residuals**2)  # Residual sum of squares
                TSS = sum(tmp.OriginalTraitValue - tmp.OriginalTraitValue.mean()**2)  # Total sum of squares
                RSq = 1 - (RSS/TSS)
                n = len(tmp.ConTemp) #set sample size
                pPow = 4

                #Calculate AIC
                AIC = n + 2 + n * np.log((2 * math.pi) / n) +  n * np.log(RSS) + 2 * pPow
                
                #adjust index
                j = i-1
                print(i)
                #Transform these into an array
                paras[j,:] = np.append(par, [RSq, AIC])
        except:
            pass
    return(paras)

def main(argv):
    """ Build Linear model and prints parameter estimates and AIC """

    #read in data
    TempResp = pd.read_csv(argv[1])

    #drop Na values from OriginalTraitValue
    TempResp['ConTemp'] = 273.15+TempResp['ConTemp']
    
    if argv[2] == 'Briere':
        TempResp = TempResp[TempResp['ConTemp'] > 0]
        TempResp = TempResp[TempResp['OriginalTraitValue'] > 0]
    
    # argv[1] = 'Line' for straight line model, 'Quadratic' for quadratic model, 'Cubic' for cubic model
    paras = Lin_Mod(TempResp, argv[2])
    if argv[2] == 'Briere':
        Results = pd.DataFrame(data = paras, columns=["B0", "t0", "tm", "RSq", "AICS"])
        Results.to_csv("../Results/Briere.csv")
    if argv[2] == 'Schoolfield':
        Results = pd.DataFrame(data = paras, columns=["B0", "El", "Eh", "Tl", "Th", "E", "RSq", "AIC"])
        Results.to_csv("../Results/Schoolfield.csv")
    if argv[2] == 'Line':
        Results = pd.DataFrame(data = paras, columns=["m", "c", "RSq", "AIC"])
        Results.to_csv("../Results/Line.csv")
    if argv[2] == 'Quadratic':
        Results = pd.DataFrame(data = paras, columns=["a", "b", "c", "RSq", "AIC"])
        Results.to_csv("../Results/Quadratic.csv")
    if argv[2] == 'Cubic':
        Results = pd.DataFrame(data = paras, columns=["a", "b", "c", "d", "RSq", "AIC"])
        Results.to_csv("../Results/Cubic.csv")
    print(paras)
    
    return 0

if __name__ == "__main__": 
    """Makes sure the "main" function is called from command line"""  
    status = main(sys.argv)
    sys.exit(status)