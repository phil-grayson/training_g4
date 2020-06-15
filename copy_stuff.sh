#!/bin/bash

#SBATCH -J        # Name for the job (keep it short and informative)
#SBATCH -N        # Number of nodes
#SBATCH -n        # Use n cores
#SBATCH -t        # Runtime in D-HH:MM 
#SBATCH --mem     # Memory requested (mb default, or specify G for Gb) 
#SBATCH -o        # File to which STDOUT will be written 
#SBATCH -e        # File to which STDERR will be written 
#SBATCH --account # Who are are going to charge it to?

# do something
