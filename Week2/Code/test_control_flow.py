#!/usr/bin/env python3

"""Some functions exemplifying the use of control statements"""
#docstrings are considered part of the running code (normal comments are
#stripped). Hence, you can access your docstrings at run time.
__appname__ = 'control_flow.py'
__author__ = 'Samraat Pawar (s.pawar@imperial.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys
import doctest


def even_or_odd(x=0):
	"""Find whether a number x is even or odd.
      
	>>> even_or_odd(10)
	'10 is Even!'
    
	>>> even_or_odd(5)
	'5 is Odd!'
    
	whenever a float is provided, then the closest integer is used:    
	>>> even_or_odd(3.2)
	'3 is Odd!'
    
	in case of negative numbers, the positive is taken:    
	>>> even_or_odd(-2)
	'-2 is Even!'
    
	"""
	#Define function to be tested
	if x % 2 == 0:
		return "%d is Even!" % x
	return "%d is Odd!" % x

####### I SUPPRESSED THIS BLOCK SO THAT DOCTEST CAN BE IN CONTROL OF THE FUNCTIONS AND IMPLEMENT IT'S OWN FLOW #######
#def main(argv):
#	print(even_or_odd(22))
#	print(even_or_odd(33))
#	print(largest_divisor_five(120))
#	print(largest_divisor_five(121))
#	print(is_prime(60))
#	print(is_prime(59))
#	print(find_all_primes(100))
#	return 0

#if __name__ == "__main__":
#	""" Makes sure the "main" function is called from command line """
#	status = main(sys.argv)
#	sys.exit(status)
#####################################################################################################################

doctest.testmod() #To run with embedded tests