#!/usr/bin/env python3

"""Debugs the is_an_oak function and modifies it's output"""

__appname__ = '[oaks_debugme.py]'
__author__ = 'CMEE G1'
__version__= '0.0.1'
__license__ = "License for this code/program"

import csv
import sys

#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus' 
     >>> is_an_oak('Quercus')
    True

    >>> is_an_oak('Pinus')
    False

    >>> is_an_oak('Quercus robur')
    True

    >>> is_an_oak('Quercuss')
    True

    >>> is_an_oak('Quercuss robur')
    False

    >>> is_an_oak('QQuercus')
    False

    >>> is_an_oak('QUERCUS')
    True
    """
    return name.lower().startswith('quercus')

    
def main(argv): 
    """Main function that runs"""
    f = open('../Data/TestOaksData.csv','r')
    g = open('../Data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    csvwrite.writerow(["Genus", "species"])

    for row in taxa:
        if row[0].lower() != "genus":
            print(row)
            print("The genus is: ") 
            print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0
    
if (__name__ == "__main__"):
    """Ensures main functions runs when script is called"""
    status = main(sys.argv)
