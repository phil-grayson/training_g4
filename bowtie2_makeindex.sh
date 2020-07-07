#!/bin/bash


#SBATCH -J Bowtie2inx 
#SBATCH -N 1                      # Ensure that all cores are on one machine
#SBATCH -n 1                # Use n cores for one job 
#SBATCH -t 0-02:59                # Runtime in D-HH:MM 
#SBATCH --mem=8000            # Memory pool for all cores 
#SBATCH -o bt2index.%A.out       # File to which STDOUT will be written 
#SBATCH -e bt2index.%A.err       # File to which STDERR will be written 
#SBATCH --account=def-coling

module load bowtie2

#1 is fasta genome #2 is name for index
bowtie2-build $1 $2
