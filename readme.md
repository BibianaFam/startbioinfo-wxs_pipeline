# StartBioinfo WXS pipeline

Educational workflow for germline variant calling from Whole Exome Sequencing data.
This repository was developed for training purposes and demonstrates the main steps of a standard NGS analysis workflow.

---

## Pipeline steps

The workflow includes:

1. Reference genome setup
2. FASTQ download
3. Quality control (FastQC)
4. Read alignment (BWA)
5. BAM processing (SAMtools + Freebayes)
6. VCF filter (bcftools)

---

## Requirements

Recommended system:

Linux  
8-16 GB RAM  
~20 GB disk space  

Software requirements handled by conda

---

## Installation

Create environment:
conda env create -f environment.yml

Activate:
conda activate startbioinfo

---

## Running the workflow
### 1 Download references
scripts/setup_ref.sh

This downloads:
hg38 reference  

#optional other reference o Broad bucket...
dbSNP  
known indels  
exome intervals  

---

### 2 Download example data
scripts/download_wxs.sh

This downloads:
NA19648 wxs sample

---

### 3 Run pipeline
scripts/run_wxs.sh

This performs:

FastQC  
Alignment  
Variant calling  

---

## Output structure
Results are stored in:

results/

qc/
  FastQC reports

bam/
  Aligned BAM files

metrics/
  Alignment statistics

vcf/
  Variant calls

---

## Notes
This workflow is intended only for training purposes. NOT optimized for large scale or clinical production analysis.


---


## License

MIT License
