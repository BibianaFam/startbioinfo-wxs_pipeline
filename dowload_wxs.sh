#!/usr/bin/env bash
set -euo pipefail

mkdir -p fastq
cd fastq

sample="NA19648"

# baixar amostra NA19648
echo "Baixando amostra de exoma..."
wget -c -O "${sample}_1.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR099/SRR099389/SRR099389_1.fastq.gz
wget -c -O "${sample}_2.fastq.gz" ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR099/SRR099389/SRR099389_2.fastq.gz

ls -lh "${sample}"_*.fastq.gz
