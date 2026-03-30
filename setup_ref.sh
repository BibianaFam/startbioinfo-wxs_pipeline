#!/usr/bin/env bash

mkdir -p ref/hg38
cd ref/hg38

#Baixar as referências para montar o exoma
echo "Baixando referênciahg38 Broad bucket..."
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

echo "Referência hg38 pronta"

#Agora vamos arrumar os targets de sequenciamento do exoma
echo "Baixando intervalo Broad b37..."
mkdir -p intervals
cd intervals

wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.annotation.gtf.gz

zgrep exon gencode.v44.annotation.gtf.gz \
| awk '{print $1"\t"$4"\t"$5}' \
> hg38_exons.bed

sort -k1,1 -k2,2n hg38_exons.bed | uniq > hg38_exons_sorted.bed

gatk BedToIntervalList \
I=hg38_exons_sorted.bed \
O=hg38_exome.interval_list \
SD=../hg38/Homo_sapiens_assembly38.dict

#baixar o pth para o liftover de versões
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz

gatk LiftOverIntervalList \
  I=Broad.human.exome.b37.interval_list \
  O=Broad.human.exome.hg38.interval_list \
  SD=../hg38/Homo_sapiens_assembly38.dict \
  CHAIN=hg19ToHg38.over.chain.gz
