########################
# STORING OBJECTS
########################
# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../Sandbox/testp.p', 'wb') #note the b: accept binary files
pickle.dump(my_dictionary, f)
f.close()

print(another_dictionary)