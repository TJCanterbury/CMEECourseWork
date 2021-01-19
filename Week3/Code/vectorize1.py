#!/usr/bin/env python3

"""Translating a matrix based R script to python"""
__author__ = 'Amisha (a.bhojwani20@imperial.ac.uk)'
__version__ = '0.0.1'

import numpy as np
from numpy import random
import time

M = np.random.rand(1000000)
M = M.reshape(1000, 1000) #np.array of random numbers from a uniform distribution

def SumAllElements(an_array):
    """Defining a sum function for an array"""
    Dimensions = np.shape(an_array)
    Tot = 0
    for i in range(1, Dimensions[0]):
        for j in range(1, Dimensions[1]):
            Tot = Tot + an_array[i,j]
    return Tot

#timing the functions
startloop = time.time()
funcMsum=SumAllElements(M)
print("Using loops in Python, Vectorise1 takes", round(time.time() - startloop, 2), "seconds")

start_inbuilt = time.time()
Msum=np.sum(M)
print("Using the in-built vectorized function in Python, Vectorize1 takes", round(time.time() - start_inbuilt, 2), "seconds")