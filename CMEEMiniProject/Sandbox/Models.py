#!/usr/bin/env python3

""" This script can either otuput a plot of a given ID or the AIC results of multiple linear 
and non linear models of temperature performance curves """

__appname__ = 'Models.py'
__author__ = 'Tristan JC (tjc19@ic.ac.uk)'
__version__ = '0.0.Godknows'

## imports ##
import sys # module to interface our program with the operating system
from lmfit import Minimizer, Parameters, report_fit
import numpy as np
import scipy.stats
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
	
	#Cubic model
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
	if min(x.ConTemp)>284:
		if (x.ConTemp[1] - x.ConTemp[0]) > 0 :
			m = (x.OriginalTraitValue[1] - x.OriginalTraitValue[0])/(x.ConTemp[1] - x.ConTemp[0])
		if (x.ConTemp[2] - x.ConTemp[0]) > 0 :
			m = (x.OriginalTraitValue[2] - x.OriginalTraitValue[0])/(x.ConTemp[2] - x.ConTemp[0])
		c = x.OriginalTraitValue[0]- (abs(m) * x.ConTemp[0])
		B0 = abs(m)*283.15 + c
	if min(x.ConTemp)<=284:
		B0 = np.mean(x.OriginalTraitValue[x.ConTemp == min(x.ConTemp, key=lambda z:abs(z - 283.15))])
	if B0 < 0 :
		B0 = 5
	Eee = np.log(B0) - x.OriginalTraitValue[2]/(1/((x.ConTemp[2])*k) - 1/283.15)

	mAx = max(x.OriginalTraitValue)
	Opt = np.mean(x.ConTemp[x.OriginalTraitValue == mAx])
	y = x[x.ConTemp >= Opt]
	w = x[x.ConTemp <= Opt]
	Tl = np.mean(w.ConTemp[w.OriginalTraitValue == min(w.OriginalTraitValue, key=lambda z:abs(z - mAx/2))])
	Th = np.mean(y.ConTemp[y.OriginalTraitValue == min(y.OriginalTraitValue, key=lambda z:abs(z - mAx/2))])
	El = -Eee 
	E = Eee 
	Eh = Eee 
	if Tl <=0 or Th <= 0 or Eee == 0 :
		Ran = True
	
	
	if Ran:
		#Randomify:
		B0 = np.random.uniform(0, 20, size = 1)
		El = np.random.uniform(-3, 0, size = 1)
		Eh = np.random.uniform(0, 3, size = 1)
		Tl = np.random.uniform(200, 300, size = 1)
		Th = np.random.uniform(300, 400, size = 1)
		E = np.random.uniform(-1.5, 1.5, size = 1)
	
	#Define and outparams_school = Parameters()
	params_school = Parameters()
	params_school.add('B0', value = B0, min = -100, max = 100)
	params_school.add('El', value = El, min = -100, max = 0)
	params_school.add('Eh', value = Eh, min = 0, max = 100)
	params_school.add('Tl', value = Tl, min = 0, max = 300)
	params_school.add('Th', value = Th, min = 100, max = 400)
	params_school.add('E', value = E, min = -100, max = 100)
	return params_school

def Starting_vals_Briere(x, Ran = False):
	""" Find starting values for Schoolfield model parameters """
	
	B = 1
	tmin = min(x.ConTemp)
	tmax = max(x.ConTemp)
	t0 = tmin
	tm = tmax
	m = 2

	if Ran == True:
		#Randomify: 
		B = np.random.uniform(-5, 5, size = 1)
		t0 = np.random.uniform(240, tmin, size = 1) 
		tm = np.random.uniform(tmax, 340, size = 1)
		m = np.random.uniform(1, 4, size = 1)
	
	#Define and outparams_school = Parameters()
	params_school = Parameters()
	params_school.add('B', value = B, min = -100, max = 100)
	params_school.add('t0', value = t0, min = 0, max = tmin)
	params_school.add('tm', value = tm, min = tmax, max = 600)
	params_school.add('m', value = m, min = 1, max = 5)
	return params_school

def Lin_Mod(Data, ID, plot):
	""" Outputs parameter estimates and AIC for a given model and starting values """
	Type = ['Schoolfield', 'Briere', 'Quadratic']
	Colour = ['purple', 'green', 'orange']
	tmp = Data[Data.ID == ID]
	tmp = tmp.reset_index(drop=True)
	# array for AIC scores
	Scores = np.zeros(6)
	if len(tmp) < 6 :
		print('ID: ', ID, ' sample size is: ', len(tmp), ' so skipped')
		return(Scores)

	#Shift data up
	shifty = 0
	if min(tmp.OriginalTraitValue) < 0 :
		shifty = abs(min(tmp.OriginalTraitValue))
		tmp.OriginalTraitValue = tmp.OriginalTraitValue + shifty
	
	tmp['ConTemp'] = 273.15+tmp['ConTemp']

	for i in Type :
							
		if i == 'Quadratic':
			colour = Colour[2]
			resid = residuals_quad 
			params = Define_Parameters(['a','b','c'], [2,2,2])
			j = 3
				
			tmp = tmp.reset_index(drop=True)
			
			#create minimzer object
			minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, tmp.OriginalTraitValue))
						
			#Perform the minimization
			best_mod = minner.minimize(method = 'leastsq')
			Scores[j] = best_mod.aic

		if i == 'Schoolfield':
			colour = Colour[0]
			resid = residuals_school
			params = Starting_vals_school(tmp)
			j = 1
			tmp = tmp.reset_index(drop=True)
			
			#create minimzer object
			minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, tmp.OriginalTraitValue))
					
			#Perform the minimization
			fit_Mod = minner.minimize(method = 'leastsq')
			best_mod = fit_Mod
			best_score = fit_Mod.aic
			Scores[j] = fit_Mod.aic

			for l in range(5):
				try:
					params = Starting_vals_school(tmp, True)
									
					#create minimzer object
					minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, tmp.OriginalTraitValue))
							
					#Perform the minimization
					fit_Mod = minner.minimize(method = 'leastsq')
					if fit_Mod.aic < best_score :
						best_mod = fit_Mod
						best_score = fit_Mod.aic
						Scores[j] = fit_Mod.aic
				except:
					pass
			
		if i == 'Briere':
			colour = Colour[1]
			resid = residuals_Briere
			params = Starting_vals_Briere(tmp)
			j = 2
			tmp = tmp.reset_index(drop=True)
			
			#create minimzer object
			minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, tmp.OriginalTraitValue))
						
			#Perform the minimization
			fit_Mod = minner.minimize(method = 'leastsq')
			best_mod = fit_Mod
			best_score = fit_Mod.aic
			Scores[j] = fit_Mod.aic
			
			for l in range(5):
				try:
					
					params = Starting_vals_Briere(tmp, Ran = True)
					#create minimzer object
					minner = Minimizer(resid, params, fcn_args=(tmp.ConTemp, tmp.OriginalTraitValue))
							
					#Perform the minimization
					fit_Mod = minner.minimize(method = 'leastsq')
					if fit_Mod.aic < best_score :
						best_mod = fit_Mod
						best_score = fit_Mod.aic
						Scores[j] = fit_Mod.aic
				except:
					pass
			
		if plot == 'Plot':        # Plot this model type
			print(i)
			print(report_fit(best_mod))
			result = tmp.OriginalTraitValue + best_mod.residual
			t_vec = np.linspace(min(tmp.ConTemp),max(tmp.ConTemp),1000)
			N_vec = np.ones(len(t_vec))
			residual_smooth = resid(best_mod.params, t_vec, N_vec)
			predictedVal = residual_smooth + N_vec
			p.plot(t_vec, (predictedVal - shifty), colour, linestyle = '--', linewidth = 1)
	
	Scores[0] = ID
	Scores[4] = max(tmp.ConTemp) - min(tmp.ConTemp)
	Scores[5] = (max(tmp.ConTemp) - min(tmp.ConTemp))/len(tmp)

	if plot == 'Plot':  
		p.plot(tmp.ConTemp, (tmp.OriginalTraitValue - shifty), 'b+')
		p.legend(fontsize = 10, labels = ['Schoolfield', 'Briere', 'Quadratic', 'Data'])
		p.xlabel('Temperature (K)', fontsize = 10)
		p.ylabel('Original Trait Valaue', fontsize = 10)
		p.ticklabel_format(style='scientific', scilimits=[0,3])
		p.title('ID :' + str(ID))
		p.savefig('../Results/plot110.pdf')
		p.close()
	return(Scores)

def main(argv):
	""" Build Linear model and prints parameter estimates and AIC """
	#prep
	fields = ['ID', 'ConTemp', 'OriginalTraitValue']
	Num = int(argv[2])
	
	#read in data
	TempResp = pd.read_csv(argv[1], usecols = fields, dtype={'ID': int, 'ConTemp': float, 'OriginalTraitValue': float}) 
	
	# Option Plot: Best fit for ID given by argv[2]
	if argv[3] == 'Plot':
		Lin_Mod(TempResp, Num, argv[3])

	# Option Stats: Record best AICs for each ID up to ID given by argv[2]
	if argv[3] == 'Stats':
		paras = np.zeros((Num-1, 6))
		print('Schoolfield', 'Briere', 'Quadratic', end = '\n')
		for i in range(1, Num):
			# For each ID attempt to fit every model, if this fails move on to next ID
			try:
				paras[i-1,:] = Lin_Mod(TempResp, i, argv[3])
				print('ID: ', i, ' ', 'Schoolfield AIC: ', paras[i-1,1], 'Briere AIC: ', paras[i-1,2], 'Quadratic AIC: ', paras[i-1,3], end="\n")
				print('Unfiltered running mean: ', np.mean(paras[:,1]), np.mean(paras[:,2]), np.mean(paras[:,3]))
			except:
				pass
		Paras = pd.DataFrame(paras, columns = ['ID', 'Schoolfield', 'Briere', 'Quadratic', 'Range', 'Density'])
		Paras.to_csv('../Results/res.csv')
		print('\n')

if __name__ == "__main__": 
	"""Makes sure the "main" function is called from command line"""  
	status = main(sys.argv)
	sys.exit(status)