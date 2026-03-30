#!/usr/bin/env bash
set -euo pipefail

mkdir -p fastq
cd fastq

#baixar amostra NA19648
echo "Baixando amostra de exoma..."
wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR151/001/SRR1518091/SRR1518091_1.fastq.gz
wget -c ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR151/001/SRR1518091/SRR1518091_2.fastq.gz

wget -c  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR099/SRR099389/SRR099389_1.fastq.gz

wget -c  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR099/SRR099389/SRR099389_2.fastq.gz

ls -lh SRR099389_*.fastq.gz