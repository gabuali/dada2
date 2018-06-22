#!/bin/bash

#SBATCH -n 6 # Number of cores
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 0-2:00 # Runtime in D-HH:MM
#SBATCH -p general # Partition to submit to
#SBATCH --mem=10000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o dada2_16Sanalysis_%j.out # File to which STDOUT will be written
#SBATCH -e dada2_16Sanalysis_%j.err # File to which STDERR will be written

### Load dependencies
hutlab load dada2-3.6


./dada2_cli.r --input_dir=input --output_dir=output
