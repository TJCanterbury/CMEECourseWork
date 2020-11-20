#!/usr/bin/env python3
"""Attempt at optimising the profileme.py script for squaring a list and making a list of a string"""
import numpy as np
def my_squares(iters):
    out = np.array(range(iters)) ** 2
    return out

def my_join(iters, string):
    out = ''
    for i in range(iters):
        out += ", " + string
    return out

def run_my_funcs(x,y):
    print(x,y)
    my_squares(x)
    my_join(x,y)
    return 0

run_my_funcs(10000000, "my string")