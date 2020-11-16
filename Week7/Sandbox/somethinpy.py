# python II
import numpy as np
a = np.array(range(5)) # a one-dimensional array
a
print(type(a))
print(type(a[0]))
a[0]

a = np.array(range(5), float)
x = np.arange(5)
x
x = np.arange(5.) #directly specify float using decimal
x
b = np.array([i for i in range(10) if i % 2 == 1]) #odd numbers between 1 and 10 
b
c = b.tolist() #convert back to list
c
mat = np.array([[0, 1], [2, 3]])
mat
mat.shape

mat = np.array([[0, 1], [2, 3]])
mat0 = np.array([[0, 10], [-1, 3]])
np.concatenate((mat, mat0), axis = 0)

mat.ravel()
mat.reshape((4,1))
mat.reshape((1,4))

# preallocate
np.zeros((4,2))
np.ones((4,2))
m = np.identity(4)

#numpy matrices
mm = np.arange(16)
mm = mm.reshape(4,4) #Convert to matrix
mm
mm + mm.transpose
mm - mm.transpose
mm // (mm + 1).transpose()

mm*np.pi
mm.dot(mm)
mm = np.matrix(mm) # convert to scipy/numpy matrix class
mm

mm * mm # instead of mm.dot(mm)

#scipy stats
import scipy.stats
scipy.stats.norm.rvs(size = 10) # 10 samples from N(0,1)
scipy.stats.randint.rvs(0, 10, size =7) # Random integers between 0 and 10
