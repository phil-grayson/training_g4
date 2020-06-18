#!/bin/bash
#SBATCH -J fastqc
#SBATCH -n 1                     # Use 1 cores for the job
#SBATCH -t 7-00:00                 # Runtime in D-HH:MM
#SBATCH --mem=800               # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o fastqc.%A.out  # File to which STDOUT will be written
#SBATCH -e fastqc.%A.err  # File to which STDERR will be written
#SBATCH --account=#def-docker or def-coling

# must be executed twice: 
# sbatch fastqc_mem_long.sh R1
# sbatch fastqc_mem_long.sh R2 

module load fastqc/0.11.8

for file in $(ls *${1}*gz); do fastqc -f fastq $file; done
