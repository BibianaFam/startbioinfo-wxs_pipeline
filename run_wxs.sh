#!/usr/bin/env bash
set -euo pipefail

#inicializar conda
conda activate startbioinfo

#setar o local dos arquivos
R1="fastq/SRR099389_1.fastq.gz"
R2="fastq/SRR099389_2.fastq.gz"

sample="NA19648"
threads="${threads:-4}"
ref="ref/hg38/Homo_sapiens_assembly38.fasta"
dbsnp="ref/hg38/Homo_sapiens_assembly38.dbsnp138.vcf"
known1="ref/hg38/Homo_sapiens_assembly38.known_indels.vcf.gz"
known2="ref/hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
target="ref/intervals/hg38_exome.interval_list"
#pode adicionar outras referências como hapmap,omni...

#criar as pastas de output
mkdir -p results/qc results/bam results/metrics results/gvcf

# analisar a qualidade das reads- FastQC
fastqc -t "${threads}" -o results/qc "${R1}" "${R2}"

# alinhar as reads com o genoma de referÊncia
echo "mapeamento com o bwa"
bwa mem -M -t "${threads}" -R "@RG\tID:${sample}\tSM:${sample}\tPL:ILLUMINA\tLB:${sample}_lib1\tPU:${sample}_unit1" "${ref}" "${R1}" "${R2}" | samtools sort -@ "${threads}" -o "results/bam/${sample}.sorted.bam" -
samtools index "results/bam/${sample}.sorted.bam"

# marcar duplicatas
gatk MarkDuplicates \
  -I "results/bam/${sample}.sorted.bam" \
  -O "results/bam/${sample}.markdup.bam" \
  -M "results/metrics/${sample}.markdup.metrics.txt" \
  --CREATE_INDEX true

# fazer a calibração das bases e aplicar o modelo
gatk BaseRecalibrator \
  -R "${ref}" \
  -I "results/bam/${sample}.markdup.bam" \
  --known-sites "${dbsnp}" \
  --known-sites "${known1}" \
  --known-sites "${known2}" \
  -L "${target}" \
  -O "results/bam/${sample}.recal.table"

gatk ApplyBQSR \
  -R "${ref}" \
  -I "results/bam/${sample}.markdup.bam" \
  --bqsr-recal-file "results/bam/${sample}.recal.table" \
  -L "${target}" \
  -O "results/bam/${sample}.recal.bam"
samtools index "results/bam/${sample}.recal.bam"

# métricas
samtools flagstat "results/bam/${sample}.recal.bam" > "results/metrics/${sample}.flagstat.txt"

#chamada de variantes
gatk HaplotypeCaller \
  -R "${ref}" \
  -I "results/bam/${sample}.recal.bam" \
  -L "${target}" \
  -ERC GVCF \
  -O "results/gvcf/${sample}.g.vcf.gz"

# criar o vcf raw
gatk GenotypeGVCFs \
-R "${ref}" \
-V "results/gvcf/${sample}.g.vcf.gz" \
-O "results/gvcf/${sample}.vcf.gz"

#Para análises a nível de coorte utiliza o CombineGVCFs e depois fazer o Joint genotyping GenotypeGVCFs
bcftools view -v snps,indels \
"results/gvcf/${sample}.vcf.gz" \
-Oz \
-o "results/gvcf/${sample}.raw.snps_indels.vcf.gz"
bcftools index -f NA19648.raw.snps_indels.vcf.gz

bcftools view -H NA19648.raw.snps_indels.vcf.gz | wc -l
bcftools stats NA19648.raw.snps_indels.vcf.gz > NA19648.raw.snps_indels.stats.txt

echo "Fim"
