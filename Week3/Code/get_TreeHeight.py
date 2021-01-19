#!/usr/bin/env python3

"""Recieves inputs from csv of tree mesurments and outputs tree height"""

__appname__ = 'get_TreeHeight.py'
__author__ = 'CMEE Group 1'
__version__= '0.0.1'
__license__ = "License for this code/program"


##Imports##
import sys
import math
import csv
import pandas as pd

##Functions##

def CalcHeight(Degrees, Distance):
    """Calculates the height of a tree given the angle and the distance away as a list"""
    heightlist = []
    for i in range(len(Degrees)):
        radians = Degrees[i] * math.pi/180
        height = Distance[i] * math.tan(radians)
        heightlist.append(height)    
    return(heightlist)


def readwritecsv(path):
    """Reads the degree and distance from the csv, calculates the heights and outputs a dataframe with a new column"""
    df = pd.read_csv(path)
    Degrees = df['Angle.degrees']
    Distance = df['Distance.m']
    Heights = CalcHeight(Degrees,Distance)

    df['Tree.Height.m'] = Heights
    return(df)


def Filename(path):
    """Obtains the file name of the input file from the path"""
    fullpath = path
    pathlist = fullpath.rsplit('/') #split the path string by '/'
    filename = pathlist[len(pathlist)-1] #Obtatain the final one in the list
    name = filename.rsplit('.')[0] # Strip the file name by '.' and obtain the first one
    return(name)


def main(argv):
    """Main function that is ran"""
    if len(argv) == 2:
        file= argv[1]
    else:        
        print("No input file found, using default")
        file = "../Data/trees.csv"
    
    df = readwritecsv(file)
    Name = Filename(file)
    df.to_csv('../Results/'+Name+'_treeHTs_Python.csv', header=True)


if __name__ == "__main__":
    """Makes sure main function runs when script is ran"""
    status=main(sys.argv)
    sys.exit(status)


