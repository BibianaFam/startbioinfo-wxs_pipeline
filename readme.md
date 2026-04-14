# StartBioinfo WXS pipeline

Educational workflow for germline variant calling from Whole Exome Sequencing data following GATK Best Practices.
This repository was developed for training purposes and demonstrates the main steps of a standard NGS analysis workflow.

---

## Pipeline steps

The workflow includes:

1. Reference genome setup
2. FASTQ download
3. Quality control (FastQC)
4. Read alignment (BWA)
5. BAM processing (SAMtools + GATK)
6. Duplicate marking
7. Base Quality Score Recalibration (BQSR)
8. Variant calling (HaplotypeCaller)
9. Generation of gVCF files

---

## Requirements

Recommended system:

Linux  
8–16 GB RAM  
20 GB disk space  

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
Duplicate marking  
BQSR  
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

gvcf/
  Variant calls

---

## Expected disk usage
References:
~20GB

FASTQ:
~15GB

BAM processing:
~40GB

Recommended total:
~80GB

---

## Notes
This workflow is intended only for training purposes. NOT optimized for large scale or clinical production analysis.


---


## License

MIT License
