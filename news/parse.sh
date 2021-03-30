#!/bin/bash
#SBATCH -t 08:30:00          # walltime = 8 hours and 30 minutes
#SBATCH -n 1                 # one CPU (hyperthreaded) cores
#SBATCH --job-name=parse_news
#SBATCH --mem=16G
#SBATCH --mail-user=<yiwenwan@mit.edu>
#SBATCH --mail-type=ALL
#SBATCH -o %x #job name

echo "data entry: $1";
hostname

python json2txt.py --num_data $1
