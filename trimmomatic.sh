#!/bin/bash

#SBATCH -n 8
#SBATCH -N 1
#SBATCH --mem 12000
#SBATCH -t 0-03:00
#SBATCH -J trimFastq
#SBATCH -o trim_%j.out
#SBATCH -e trim_%j.err

#specify the name of the first pair as the first argument on the command line and the base name for the output as the second argument
#e.g., 

module load trimmomatic-0.36

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar PE -threads 8 $1 $2 trim_${1} unpaired_${1} trim_${2} unpaired_${2} ILLUMINACLIP:adapters.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:90
