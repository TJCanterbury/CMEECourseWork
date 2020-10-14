#!/usr/bin/env ipython3

"""Some functions exemplifying the use of control statements"""
__author__ = 'Tristan Canterbury (tjc19@ic.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys

## functions ##
def foo_1(x=25): # returns the square root of x
    return x ** 0.5

def foo_2(x=4, y=3): # returns the bigger of 2 values
    if x > y:
        return x
    return y

def foo_3(x=0.023, y=0.99, z=0.001): # Moves the largest variable to the end of the vector
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x=5): # Calculates factorial of x using the range function for explicitness
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x=6): # a recursive function that calculates the factorial of x
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     
def foo_6(x=7): # Calculate the factorial of x in a different way
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
     
def main(argv):
    print(foo_1())
    print(foo_2())
    print(foo_3())
    print(foo_4())
    print(foo_5())
    print(foo_6())
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)