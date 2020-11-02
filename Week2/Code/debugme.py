""" buggy code example """
def makeabug(x):
    y = x**4
    z = 0
    y = y/z
    return y

makeabug(25)