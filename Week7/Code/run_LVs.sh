#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: run_LVs.sh
# Desc: Run LV1.py and LV2.py profile using cprofile via python3
# Arguments: none
# Date: Nov 2020

python3 -m cProfile LV1.py
python3 -m cProfile LV2.py