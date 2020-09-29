#!/bin/bash

#SBATCH -J bgzip   # Name for the job (keep it short and informative)
#SBATCH -N 1       # Number of nodes
#SBATCH -n 1       # Use n cores
#SBATCH -t 1-00:00     # Runtime in D-HH:MM 
#SBATCH --mem=3900 # Memory requested (mb default, or specify G for Gb) 
#SBATCH -o bgzip.%A.out       # File to which STDOUT will be written 
#SBATCH -e bgzip.%A.err       # File to which STDERR will be written 
#SBATCH --account=def-coling # Who are are going to charge it to?

module load bcftools/1.9

bgzip -c $1 > ${1}.gz
