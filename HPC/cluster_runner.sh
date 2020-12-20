#!/bin/bash
#PBS -l walltime=12:30:00
#PBS -l select=1:ncpus=1:mem=1gb
module load anaconda3/personal
echo "R is about to run"
Rscript --vanilla $HOME/tcanterbury_HPC_2020_cluster.R 
mv Result_file_* $HOME
echo "R has finished running"