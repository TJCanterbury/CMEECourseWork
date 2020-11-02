""" Dictionary manipulation in Python """
taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc.  


taxa_dic = {}
for species in taxa:
        tmp = species[1]
        taxa_dic[species[1]] = set([species[0] \
        for species in taxa if tmp == species[1]])
print(taxa_dic)

# or:
# but I don't fully understand this one as it is internet sourced so not using it yet XD
# print("\n".join("{}\t{}".format(k, v) for k, v in taxa_dic.items()))
