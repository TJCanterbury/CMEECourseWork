#!/usr/bin/env python3

"""simple alignement program for 2 DNA sequences"""

__appname__ = 'align_seqs.py'
__author__ = 'CMEE Group 1'
__version__ = '0.0.1'

## imports ##
import sys
#may need to install Biopython


## functions ##


# Assign the longer sequence s1, and the shorter to s2
# l1 is length of the longest, l2 that of the shortest
def read_fasta(File):
	"""reads fasta file and output sequence"""
	with open(File,'r') as f:
		SeqList = f.read().splitlines() # Reads the txt file, and make each line within a list
		SeqOnly = SeqList[1:len(SeqList)] #Removes the first line
		Seq = ''.join(SeqOnly) #Joins each item on the SeqOnly list to a single string
	return(Seq)

def mulordseq(seq1, seq2):
	"""puts sequences from 2 different files in size order and gives their respective lengths"""
	l1 = len(seq1)
	l2 = len(seq2)
	if l1 >= l2:
		s1 = seq1
		s2 = seq2
	else:
		s1 = seq2
		s2 = seq1
		l1, l2 = l2, l1 # swap the two lengths
	return s1, s2, l1, l2


# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
	"""calculates the alignment score fror a given alignment"""
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
	print("Testing startpoint: ", startpoint, " Score = ", score, end="\r")

	return score

def bestalig(s1, s2, l1, l2):
	"""finds one of the best of all possible alignments"""
	# now try to find the best match (highest score) for the two sequences
	my_best_align = None
	my_best_score = -1

	for i in range(l1): # Note that you just take the last alignment with the highest score
		z = calculate_score(s1, s2, l1, l2, i)
		if z > my_best_score:
			my_best_align = "." * i + s2 # think about what this is doing!
			my_best_score = z  
	f=open("../Results/bestalig.txt", "w+")
	f.write("Best alignment: %s\n" % my_best_align) 
	f.write("                %s\n" % s1)
	f.write("Alignment score: %d" % my_best_score)
	f.close()
	print("Done! You will find your aligned sequences at '../Results/bestalig.txt'")
	return 0


def main(argv):
	"""this is the main function"""
	if len(argv) == 1:
		print("No arguments given, using test .fasta files '../Data/407228412.fasta', '../Data/407228326.fasta'")
		seq1 = read_fasta("../Data/407228412.fasta")
		seq2 = read_fasta("../Data/407228326.fasta")
		s= mulordseq(seq1,seq2)
		bestalig(s[0], s[1], s[2], s[3])
	elif len(argv)==3:
		if argv[1:2].endswith('.fasta'):
			seq1 = read_fasta("../Data/407228412.fasta")
			seq2 = read_fasta("../Data/407228326.fasta")
			s= mulordseq(seq1,seq2)
			bestalig(s[0], s[1], s[2], s[3])
		else:
			print("Improper arguments given, program takes 2 fasta file")
	else:
		print("Improper arguments given, program takes 2 fasta file")
	return 0

if __name__ == "__main__":
	status = main(sys.argv)
	sys.exit(status)
