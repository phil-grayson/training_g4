#!/bin/bash

#SBATCH -J platy
#SBATCH -N 1                      # Ensure that all cores are on one machine
#SBATCH -n 16                # Use n cores for one job 
#SBATCH -t 2-23:59                # Runtime in D-HH:MM 
#SBATCH --mem-per-cpu=2100 #--mem=10000            # Memory pool for all cores 
#SBATCH -o Platy.%A.out       # File to which STDOUT will be written 
#SBATCH -e Platy.%A.err       # File to which STDERR will be written 
#SBATCH --account=def-docker_cpu

module load samtools
module load bcftools
source ~/cython/bin/activate

python /home/pgrayson/programs/Platypus/bin/Platypus.py callVariants --nCPU=16 --bamFiles=${1} --refFile=${2} --output=platy_all_VGP.vcf
