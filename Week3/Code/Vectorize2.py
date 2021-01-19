#!/usr/bin/env python3

"""Translating the StochRick R script to python"""
__author__ = 'CMEE Group 1'
__version__ = '0.0.1'

import numpy as np
from numpy import random
import time

def stochrick(p0=np.random.uniform(0.5, 1.5, 1000), r=1.2, K=1, sigma=0.2, numyears=100):
    """Stochastic Ricker function"""
    M = np.empty(shape=(numyears,len(p0))) #empty matrix to store results
    M[0] = p0 #first row is randomly generated starting population

    for pop in range(0, len(p0)):
        for yr in range(1, numyears):
            M[yr, pop] = (M[yr-1, pop]) * np.exp(r * (1 - M[yr-1,pop] / K) + random.normal(0, sigma, 1)) #to determine the population at time t, use the value of the population at t-1 
    
    return M

def stochrickvect(p0=np.random.uniform(0.5, 1.5, 1000), r=1.2, K=1, sigma=0.2, numyears=100):
    """Stochastic Ricker function"""
    N = np.empty(shape=(numyears,len(p0)))
    N[0] = p0

    for yr in range(1, numyears):
        N[yr] = N[yr-1] * np.exp(r * (1 - N[yr-1] / K) + random.normal(0, sigma, 1)) #same as stochrick func except does calculations per row instead of cell
    
    return N

#timing the functions
start_rick = time.time()
stochrick()
print("Stochastic Ricker model in Python takes", round(time.time() - start_rick, 2), "seconds")

start_rickvect = time.time()
stochrickvect()
print("Vectorised Stochastic Ricker model in Python takes:", round(time.time() - start_rickvect, 2), "seconds")