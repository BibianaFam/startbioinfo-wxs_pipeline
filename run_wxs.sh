#!/usr/bin/env bash
set -euo pipefail

#inicializar conda
#source $(conda info --base)/etc/profile.d/conda.sh
conda activate startbioinfo

#setar o local dos arquivos
R1="fastq/NA19648_1.fastq.gz"
R2="fastq/NA19648_2.fastq.gz"
sample="NA19648"
threads="${threads:-4}"
ref="ref/hg38/Homo_sapiens_assembly38.fasta"
target="ref/intervals/hg38_exome.interval_list"

# criar as pastas de output
mkdir -p results/qc results/bam results/metrics results/vcf

# analisar a qualidade das reads- FastQC
fastqc -t "${threads}" -o results/qc "${R1}" "${R2}"

# alinhar as reads com o genoma de referÊncia
echo "mapeamento com o bwa"
bwa mem -M -t "${threads}" -R "@RG\tID:${sample}\tSM:${sample}\tPL:ILLUMINA\tLB:${sample}_lib1\tPU:${sample}_unit1" "${ref}" "${R1}" "${R2}" | samtools sort -@ "${threads}" -o "results/bam/${sample}.sorted.bam" -
samtools index "results/bam/${sample}.sorted.bam"

# métricas básicas
samtools flagstat "results/bam/${sample}.recal.bam" > "results/metrics/${sample}.flagstat.txt"

# chamada de variantes
freebayes -f "${ref}" -t "${target}" "results/bam/${sample}.bam" | bgzip > "results/vcf/${sample}.freebayes.vcf.gz"
bcftools index -t "results/vcf/${sample}.freebayes.vcf.gz"

# filtrar SNPs e indels com QUAL >= 20"
bcftools view -v snps,indels "results/vcf/${sample}.freebayes.vcf.gz" | bcftools filter -i 'QUAL>=20' -Oz -o "results/vcf/${sample}.freebayes.pass.vcf.gz"

# estatísticas do VCF
bcftools stats "results/vcf/${sample}.freebayes.pass.vcf.gz" > "results/metrics/${sample}.freebayes.pass.stats.txt"

echo "fim"
