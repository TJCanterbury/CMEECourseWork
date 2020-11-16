#!/usr/bin/env python3

"""Some functions exemplifying the use of control statements"""
__author__ = 'Tristan Canterbury (tjc19@ic.ac.uk)'
__version__ = '0.0.1'

# integrating the Lotka-Volterra model
## imports ##
import sys
import numpy as np
import scipy.stats
import scipy.integrate as integrate
import matplotlib.pylab as p

## functions ##
def dCR_dt(pops, t=0, r = 1, a = 0.1, z = 1.5, e = 0.75):
    """ Returns the growth rate of consumer and resource population at any given time step """
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return np.array([dRdt, dCdt])


def main(argv):
    """ control flow function """
    t = np.linspace(0, 15, 1000)
    R0 = 10
    C0 = 5 
    RC0 = np.array([R0, C0])
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
    #plotting
    f1 = p.figure()
    p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
    p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
    p.grid()
    p.legend(loc='best')
    p.xlabel('Time')
    p.ylabel('Population density')
    p.title('Consumer-Resource population dynamics')
    f1.savefig('../Results/LV_model.pdf') #Save figure
    p.close()
    f1 = p.figure()
    p.plot(pops[:,0], pops[:,1], 'r')
    p.ylabel('Consumer density')
    p.xlabel('Resource density')
    p.title('Consummer-Resource population dynamics')
    p.grid()
    f1.savefig('../Results/Dyn_LV_model.pdf')
    p.close()
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)