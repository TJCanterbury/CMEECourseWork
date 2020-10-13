birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 
# latin names (gs - genus species)
birdgs1 = [species[0] for species in birds]
print(birdgs1)

# common names
birdname1 = [species[1] for species in birds]
print(birdname1)

# mean body masses
birdmass1 = [species[2] for species in birds]
print(birdmass1)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 
# latin names
birdgs2 = []
for species in birds:
    birdgs2.append(species[0])
print(birdgs2)

# common names
birdname2 = []
for species in birds:
    birdname2.append(species[1])
print(birdname2)

# mean body mass
birdmass2 = []
for species in birds:
    birdmass2.append(species[2])
print(birdmass2)
