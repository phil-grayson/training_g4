#!/bin/bash

# Call this script with 2 fastq file2 for reads 1 and 2.
#
# e.g. sbatch [thisscript.sh](http://thisscript.sh) myfile.R1.fastq  myfile.R2.fastq
#
# myfile.R1.fastq is referenced by the variable $1
# myfile.R2.fastq is referenced by the variable $2
# $3 is the base name of your bowtie2 index

#SBATCH -J Bowtie2 
#SBATCH -N 1                      # Ensure that all cores are on one machine
#SBATCH -n 8                # Use n cores for one job 
#SBATCH -t 0-12:00                # Runtime in D-HH:MM 
#SBATCH --mem=4000            # Memory pool for all cores 
#SBATCH -o bt2.%A.out       # File to which STDOUT will be written 
#SBATCH -e bt2.%A.err       # File to which STDERR will be written 
#SBATCH --account=def-coling # or def-docker

module load bowtie2 # need version here
module load samtools # need version here

bowtie2 -x $3 -1 $1 -2 $2 -X 2000 -p 8 | samtools view -b -S - |samtools sort - -o 8_${1}.bam

samtools index 8_${1}.bam
