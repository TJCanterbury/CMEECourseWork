""" Find files and directories beginning with c/C, includes versatile search function"""

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
import re

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:
def find_paths(pattern=r'^C', root='~', files = True, subdirs = True):
    """ Find the file (files = True) and/or sub directories (subdirs = True) that 
        match a given pattern (pattern = r'^C) under a given directory (root='~') """
    # Get the user's chosen directory to be searched.
    home = subprocess.os.path.expanduser(root)

    # Create a list to store the results.
    FilesDirsStartingWithC = []
    regex = re.compile(pattern)
    # Use a for loop to walk through the home directory.    
    for (dirpath, subdir, file) in subprocess.os.walk(home):
        if subdirs:
            for di in subdir:
                if regex.match(di):
                    FilesDirsStartingWithC.append(subprocess.os.path.join(dirpath, di))
        if files:
            for fi in file:
                if regex.match(fi):
                    FilesDirsStartingWithC.append(subprocess.os.path.join(dirpath, fi))
    return(FilesDirsStartingWithC)

find_paths()
  
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
find_paths(pattern = r'^c')

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:

find_paths(pattern = r'^c', files=False)