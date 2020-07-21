#!/bin/bash

#SBATCH -J sam_index 
#SBATCH -N 1                      # Ensure that all cores are on one machine
#SBATCH -n 1                # Use n cores for one job 
#SBATCH -t 0-03:00                # Runtime in D-HH:MM 
#SBATCH --mem=4000            # Memory pool for all cores 
#SBATCH -o sindex.%A.out       # File to which STDOUT will be written 
#SBATCH -e sindex.%A.err       # File to which STDERR will be written 
#SBATCH --account=def-docker

module load samtools/1.10

samtools index $1
