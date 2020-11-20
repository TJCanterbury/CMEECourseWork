#!/usr/bin/env python3
""" Runs TestR.R script via python subprocess """
import subprocess
subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout", shell = True).wait()

f = open("../Results/TestR.Rout", "r")
text = f.read()
print (text)
f.close()
f = open("../Results/TestR_errFile.Rout", "r")
text = f.read()
print (text)
f.close()