#!/usr/bin/env python3
""" Runs the fmr_R.R script via a python subprocess """
import subprocess

proc = subprocess.Popen(["Rscript", "--verbose", "fmr.R"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
stdout, stderr = proc.communicate()
print(stdout.decode())
print(stderr.decode())