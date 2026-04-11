#!/usr/bin/env bash

mkdir -p ref/hg38
cd ref/hg38

#Baixar as referências para montar o exoma
echo "baixando referênciahg38 Broad bucket..."
#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.fasta
#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.fasta.fai
#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.dict

#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf
#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.idx

#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz
#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.known_indels.vcf.gz.tbi

#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
#wget -c https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi

#bwa index Homo_sapiens_assembly38.fasta
echo "referência hg38 pronta"

# arrumar os targets de captura do sequenciamento, caso não tenha do lab pode usar o gencode
mkdir -p intervals
cd intervals
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.annotation.gtf.gz

#gerar o arquivo bed dos targets só de regiõs codificantes
zcat gencode.v44.annotation.gtf.gz | \
awk 'BEGIN{OFS="\t"} $3=="exon" && $0 ~ /tag "basic"/ && $0 ~ /gene_type "protein_coding"/ {print $1, $4-1, $5}' \
| sort -k1,1 -k2,2n | uniq > hg38_exons_basic_pc.bed
echo "fim..."

