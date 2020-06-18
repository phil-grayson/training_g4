#!/bin/bash
#SBATCH -J fastqc
#SBATCH -n 1                     # Use 1 cores for the job
#SBATCH -t 3-00:00                 # Runtime in D-HH:MM
#SBATCH --mem=800               # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o fastqc.%A.out  # File to which STDOUT will be written
#SBATCH -e fastqc.%A.err  # File to which STDERR will be written
#SBATCH --account=#def-docker or def-coling
#SBATCH --mail-user=#enter your email
#SBATCH --mail-type=ALL

# must be executed twice (once with R1 and once with R2) - this value is passed here and becomes ${1}: 
# sbatch fastqc_mem_long.sh R1
# sbatch fastqc_mem_long.sh R2 

module load fastqc/0.11.8

for file in $(ls *${1}*gz); do fastqc -f fastq $file; done
