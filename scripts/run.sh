#!/bin/bash
set -euo pipefail

# Creating directories
mkdir -p ./{data,analysis}
#mkdir -p ./{data/$(date +%F),analysis/$(date +%F)}

# Downloading data
#wget http://www.arb-silva.de/fileadmin/silva_databases/living_tree/LTP_release_123/LTPs123_SSU.compressed.fasta.tar.gz
curl -O http://www.arb-silva.de/fileadmin/silva_databases/living_tree/LTP_release_123/LTPs123_SSU.compressed.fasta.tar.gz
tar xvzf LTPs123_SSU.compressed.fasta.tar.gz
mv LTPs123_SSU.compressed.fasta* data/

# Running R scripts
#Rscript --vanilla scripts/my_fasta.R

# Running BLAST script
#bash scripts/run_blast.sh

# Print operating system characteristics
uname -a

echo "[$(date)] $0 has been successfully completed."
