#!/bin/bash

# Author: Tristan JC tjc19@ic.ac.uk
# Script: run_LVs.sh
# Desc: Run LV1.py and LV2.py using ipython3
# Arguments: none
# Date: Nov 2020

ipython3 -i -c "
%run -p LV1.py 
%run -p LV2.py
"