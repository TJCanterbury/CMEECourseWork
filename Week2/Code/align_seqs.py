#!/usr/bin/env python3

"""simple alignement program for 2 DNA sequences"""

__appname__ = 'align_seqs.py'
__author__ = 'Tristan JC (tjc19@ic.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys
from Bio import SeqIO
import pdb; pdb.set_trace()

## functions ##
def parseq(x):
    seqs = list()
    for i in SeqIO.parse(x, "fasta"): 
        seqs.append(str(i.seq))
    return seqs
pdb.set_trace()
# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest
seqs = parseq(sys.argv[1])
seq1 = seqs[0]
seq2 = seqs[1]
l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

pdb.set_trace()

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score

pdb.set_trace()

# Test the function with some example starting points:
# calculate_score(s1, s2, l1, l2, 0)
# calculate_score(s1, s2, l1, l2, 1)
# calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

for i in range(l1): # Note that you just take the last alignment with the highest score
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2 # think about what this is doing!
        my_best_score = z 


pdb.set_trace()

def main(argv):
    parseq(sys.argv[1])
    f=open("../Results/bestalig.txt", "w+")
    f.write("Best alignment: %s\n" % my_best_align)
    f.write("                %s\n" % s1)
    f.write("Alignment score: %d" % my_best_score)
    f.close()
    return 0

if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)
