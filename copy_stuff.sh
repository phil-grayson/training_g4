#!/bin/bash

#SBATCH -J copyPtoS   # Name for the job (keep it short and informative)
#SBATCH -N 1       # Number of nodes
#SBATCH -n 1       # Use n cores
#SBATCH -t 1-00:00     # Runtime in D-HH:MM 
#SBATCH --mem=1G    # Memory requested (mb default, or specify G for Gb) 
#SBATCH -o cp.%A.out       # File to which STDOUT will be written 
#SBATCH -e cp.%A.err       # File to which STDERR will be written 
#SBATCH --account=def-docker # Who are are going to charge it to?

for file in $(cat persons_samples.txt); do cp $file lamprey_June/; done
