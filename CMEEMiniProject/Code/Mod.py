#!/usr/bin/env python3

""" This script can either otuput a plot of a given ID or the AIC results of multiple linear 
and non linear models of temperature performance curves """

__appname__ = 'Mod.py'
__author__ = 'Tristan JC (tjc19@ic.ac.uk)'
__version__ = '0.0.Godknows'

## imports ##
import sys # module to interface our program with the operating system
from lmfit import Minimizer, Parameters, report_fit
import numpy as np
import scipy.stats
from scipy.stats import linregress
import matplotlib.pylab as p
import pandas as pd
import math
from csv import writer

## constants ##
k = 8.617e-5

## functions ##
def residuals_quad(params, t, data):
	"""Calculate quadratic growth and subtract data"""
	
	#Get an ordered dictionary of parameter values
	v = params.valuesdict()
	
	#Quadratic model
	model = v['a']*t**2 + v['b']*t + v['c']

	return model - data     #Return residuals

def residuals_Briere(params, t, data):
	'''Fit a Breire model and subtract data'''
	#Get an ordered dictionary of parameter values
	v = params.valuesdict()

	model = v['B'] * t * (t - v['t0']) * ((v['tm'] - t) ** (1/v['m']))
	#Return residuals
	return model - data

def residuals_school(params, t, data):
	'''Fit a Breire model and subtract data'''
	#Get an ordered dictionary of parameter values
	v = params.valuesdict()

	model = (v['B0'] * np.exp((-v['E']/k) * ((1/t) - (1/283.15))) ) / (1 + np.exp((v['El']/k) * ((1/v['Tl']) - (1/t))) + np.exp((v['Eh']/k) * ((1/v['Th']) - (1/t))))
	#Return residuals
	return model - data

def Define_Parameters(labels, values):
	"""Function for simplifying process of defining parameters"""
	par_linear = Parameters()

	for i in range(len(labels)):
		#Add parameters and initial values to it
		par_linear.add( labels[i], value = values[i])

	return par_linear

def Starting_vals_school(x, Ran = False):
	""" Find starting values for Schoolfield model parameters """
	# Estimate B0:
	lin = linregress(x[0:2,1], x[0:2,2])
	B0 = abs(lin[0])*283.15 + lin[1]
	if B0 < 0 :
		B0 = 5
	
	# Estimate El, E and Eh:
	Eee = np.log(B0) - x[2,2] / (1 / ((x[2,1]) * k) - 1 / 283.15)
	El = -Eee 
	E = Eee 
	Eh = Eee 

	# Estimate Th and Tl:
	# Find the indices for the max and min values of the curve
	mAxI = np.argmax(x[:,2])
	mInI = np.argmin(x[:,2])

	# Find estimated trait value at half way up to the peak of the curve from the bottom of the curve:
	halfway = (x[mAxI,2]  + x[mInI, 2]) / 2

	# Find a temperature value corresponding to a trait value that varies the least (.argmin()) from the halfway value
	Th = np.mean(x[(np.abs(x[mAxI:,2] - halfway)).argmin()])	# on the right hand side of the curve
	Tl = np.mean(x[(np.abs(x[:mAxI,2] - halfway)).argmin()])	# and on the left hand side

	# If calculated values are particularly wonky ignore them and use a random sample istead
	if Tl <=0 or Th <= 0 or Eee == 0 :
		Ran = True
	
	# Find random values for the parameters within somewhat biologically plausible bounds
	if Ran:
		B0 = np.random.uniform(0, 100, size = 1)
		El = np.random.uniform(-3, 0, size = 1)
		Eh = np.random.uniform(0, 3, size = 1)
		Tl = np.random.uniform(250, 350, size = 1)
		Th = np.random.uniform(250, 250, size = 1)
		E = np.random.uniform(-1.5, 1.5, size = 1)
	
	#Define and outparams_school = Parameters()
	params_school = Parameters()
	params_school.add('B0', value = B0, min = -50, max = 1000)
	params_school.add('El', value = El, min = -50, max = 50)
	params_school.add('Eh', value = Eh, min = -50, max = 50)
	params_school.add('Tl', value = Tl, min = 0, max = 600)
	params_school.add('Th', value = Th, min = 0, max = 600)
	params_school.add('E', value = E, min = -10, max = 10)

	return params_school

def Starting_vals_Briere(x, Ran = False):
	""" Find starting values for Schoolfield model parameters """
	
	B = 1
	tmin = min(x[:,1])
	tmax = max(x[:,1])
	t0 = tmin
	tm = tmax
	m = 2

	if Ran == True:
		#Randomify: 
		B = np.random.uniform(-10, 100, size = 1)
		t0 = np.random.uniform(100, tmin, size = 1) 
		tm = np.random.uniform(tmax, 500, size = 1)
		m = np.random.uniform(1, 3, size = 1)
	
	#Define and outparams_school = Parameters()
	params_school = Parameters()
	params_school.add('B', value = B, min = -50, max = 1000)
	params_school.add('t0', value = t0, min = 0, max = tmin)
	params_school.add('tm', value = tm, min = tmax, max = 1000)
	params_school.add('m', value = m, min = 1, max = 10)
	return params_school

def variance(data):
	# Number of observations
	n = len(data)
	# Mean of the data
	mean = sum(data) / n
	# Square deviations
	deviations = [(x - mean) ** 2 for x in data]
	# Variance
	variance = sum(deviations) / n
	return variance

def Bad_Mod(data, model, alpha = 0.5):
	F = variance(model.residual)/variance(data[:,2])
	p_value = scipy.stats.f.cdf(F, len(data)-1, len(data)-1)
	if p_value > alpha:
		return 1
	else: 
		return 0

def Mod_it(tmp, resid, starter):
	""" Generate model and return AIC score and parameter values """
	#create minimzer object
	minner = Minimizer(resid, starter, fcn_args=(tmp[:,1], tmp[:,2]))

	#Perform the minimization
	Mod = minner.minimize(method = 'leastsq')
	
	return(Mod)

def Schoolfield_Model(Data, n):
	""" Build Sharpe-Schoolfield Models and return mathematically estimated and the best fit models """

	S_Math_Mod = Mod_it(Data, residuals_school, Starting_vals_school(Data))
	S_Best_Mod = S_Math_Mod

	for _ in range(n):
		try:
			# Schoolfield:
			S_Ran_Mod = Mod_it(Data, residuals_school, Starting_vals_school(Data, True))
			if S_Ran_Mod.aic < S_Best_Mod.aic :
				S_Best_Mod = S_Ran_Mod
		except:
			pass

	return(S_Math_Mod, S_Best_Mod)

def Briere_Model(Data, n):
	""" Build Briere Models and return mathematically estimated and the best fit models """

	B_Math_Mod = Mod_it(Data, residuals_Briere, Starting_vals_Briere(Data))
	B_Best_Mod = B_Math_Mod

	for _ in range(n):
		try:
			B_Ran_Mod = Mod_it(Data, residuals_Briere, Starting_vals_Briere(Data, True))
			if B_Ran_Mod.aic < B_Best_Mod.aic :
				B_Best_Mod = B_Ran_Mod
		except:
			pass

	return(B_Best_Mod)

def Linear_Model(Data):
	""" Build Linear Model of chosen type (eg quadratic, cubic and beyond) and return best fit model """
	
	Lin_Mod = Mod_it(Data, residuals_quad, Define_Parameters(['a','b','c'], [2,2,2]))
	
	return(Lin_Mod)

def Figure_1(Data, ID, Mod1, Mod2, Mod3, Colour, minT, maxT, shifty):
	t_vec = np.linspace(minT,maxT,1000)
	N_vec = np.ones(len(t_vec))

	# Schoolfield:
	residual_smooth = residuals_school(Mod1.params, t_vec, N_vec)
	predictedVal = residual_smooth + N_vec
	p.plot(t_vec, (predictedVal - shifty), Colour[0], linestyle = '--', linewidth = 1)

	#Briere:
	residual_smooth = residuals_Briere(Mod2.params, t_vec, N_vec)
	predictedVal = residual_smooth + N_vec
	p.plot(t_vec, (predictedVal - shifty), Colour[1], linestyle = '--', linewidth = 1)

	#Quad:
	residual_smooth = residuals_quad(Mod3.params, t_vec, N_vec)
	predictedVal = residual_smooth + N_vec
	p.plot(t_vec, (predictedVal - shifty), Colour[2], linestyle = '--', linewidth = 1)

	p.plot(Data[:,1], (Data[:,2] - shifty), 'b+')
	p.legend(fontsize = 10, labels = ['Schoolfield', 'Briere', 'Quadratic', 'Data'])
	p.xlabel('Temperature (K)', fontsize = 10)
	p.ylabel('Original Trait Valaue', fontsize = 10)
	p.ticklabel_format(style='scientific', scilimits=[0,3])
	p.title('ID :' + str(ID))
	p.savefig('../Results/Figure1.pdf')
	p.close()

def ith_Result(Data, ID, n = 10, plot = False, alpha = 0.5):
	""" Takes Data, fits the Schoolfield, Briere and Quadratic models to the data for the given ID;
		Then Outputs parameter estimates, AIC scores and temperature range for a given ID """
	tmp = Data[Data[:,0]==ID]
	Colour = ['purple', 'green', 'orange']

	# array for AIC scores
	Scores = np.zeros(18)

	#If modelling not possible due to too small a sample size, return zeros
	if len(tmp) < 6 :
		print('ID: ', ID, ' sample size is: ', len(tmp), ' so skipped')
		return Scores
	
	#Shift data up
	shifty = 0
	if min(tmp[:,2]) < 0 :
		shifty = abs(min(tmp[:,2]))
		tmp[:,2] = tmp[:,2] + shifty
	
	# Convert to Kelvin
	tmp[:,1] = 273.15+tmp[:,1]
	minT = min(tmp[:,1])
	maxT = max(tmp[:,1])

	# Generate Models:
	# Schoolfield:
	Math_Schoolfield_mod, Best_Schoolfield_mod = Schoolfield_Model(tmp, n)
	#If modelling failed return zeros
	if Bad_Mod(tmp, Best_Schoolfield_mod, alpha):
		print("ID: ", ID, " was poorly modelled by the Sharpe-Schoolfield model")
		return Scores 

	#Quad:
	Quad_mod = Linear_Model(tmp)
	#If modelling failed return zeros
	#if Bad_Mod(tmp, Quad_mod, alpha):
	#	return Scores 

	#Briere:
	Briere_mod = Briere_Model(tmp, n)
	#If modelling failed return zeros
	#if Bad_Mod(tmp, Briere_mod, alpha):
	#	return Scores 

	if plot:
		Figure_1(tmp, ID, Best_Schoolfield_mod, Briere_mod, Quad_mod, Colour, minT, maxT, shifty)
		return

	# Allocate scores:
	Scores[0] = ID
	Scores[1] = Best_Schoolfield_mod.aic
	Scores[2] = Briere_mod.aic
	Scores[3] = Quad_mod.aic
	Scores[4] = maxT - minT
	Scores[5] = (maxT - minT)/len(tmp)
	
	# Extract parameter values for best fit
	par_dict = Best_Schoolfield_mod.params.valuesdict().values()
	School_best_par = np.array(list(par_dict))
	Scores[6:12] = School_best_par

	# Extract parameter values for mathematical fit
	par_dict = Math_Schoolfield_mod.params.valuesdict().values()
	School_Mod1_par = np.array(list(par_dict))
	Scores[12:18] = School_Mod1_par

	# adjust AIC scores for analysis
	MiNScore = min(Scores[1:4])
	Scores[1] = np.exp((MiNScore-Scores[1])/2)
	Scores[2] = np.exp((MiNScore-Scores[2])/2)
	Scores[3] = np.exp((MiNScore-Scores[3])/2)

	return(Scores)

def main(argv):
	""" Build Linear model and prints parameter estimates and AIC """
	#read in data
	fields = ['ID', 'ConTemp', 'OriginalTraitValue']
	TempResp = pd.read_csv(argv[1], usecols = fields, dtype={'ID': int, 'ConTemp': float, 'OriginalTraitValue': float}) 
	TempResp = np.array(TempResp, dtype = float)
	TempResp[:,[1, 2]] = TempResp[:,[2, 1]]
	Num = 903

	if len(argv) == 3:
		# Option Figure 1: plot figure 1
		ith_Result(TempResp, int(argv[2]), alpha=0.05, plot = True)
		return 0

	if len(argv) == 2:
		# Option Stats: Record best AICs for each ID
		paras = np.zeros((Num-1, 18))
		print('Schoolfield', 'Briere', 'Quadratic', end = '\n')
		for i in range(1, Num):
			# For each ID attempt to fit every model, if this fails move on to next ID
			try:
				paras[i-1,:] = ith_Result(TempResp, i, alpha=0.05)
				if max(paras[i-1, 1:4]) == 1:
					print('ID: ', i, ' ', 'Schoolfield AIC: ', paras[i-1,1], 'Briere AIC: ', paras[i-1,2], 'Quadratic AIC: ', paras[i-1,3], end="\n")
			except:
				pass
		
		Paras = pd.DataFrame(paras, columns = ['ID', 'Schoolfield', 'Briere', 'Quadratic', 'Range', 'Density', 'B0', 'El', 'Eh', 'Tl', 'Th', 'E', 'B01', 'El1', 'Eh1', 'Tl1', 'Th1', 'E1'])
		Paras.to_csv('../Results/res.csv')
		print('\n')
		return 0

if __name__ == "__main__": 
	"""Makes sure the "main" function is called from command line"""  
	status = main(sys.argv)
	sys.exit(status)