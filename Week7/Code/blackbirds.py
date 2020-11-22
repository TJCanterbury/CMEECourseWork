#!/usr/bin/env python3
import re
from pathlib import Path

# Read the file (using a different, more python 3 way, just for fun!)
text = Path('../Data/blackbirds.txt').read_text()

# replace \t's and \n's with a spaces:
text = re.sub('\t',' ', text)
text = re.sub('\n',' ', text)
# You may want to make other changes to the text. 

# In particular, note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform to ASCII:

text = text.encode('ascii', 'ignore') # first encode into ascii bytes
text = text.decode('ascii', 'ignore') # Now decode back to string

# Now extend this script so that it captures the Kingdom, Phylum and Species
# name for each species and prints it out to screen neatly.

print(re.findall(r'\sKingdom\s(\w*)\s.*?Phylum\s(\w*)\s.*?Species\s(\w*\s\w*?)\s', text))

# Hint: you may want to use re.findall(my_reg, text)... Keep in mind that there
# are multiple ways to skin this cat! Your solution could involve multiple
# regular expression calls (slightly easier!), or a single one (slightly harder!)