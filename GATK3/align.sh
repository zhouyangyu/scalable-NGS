#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Align raw reads to reference genome, FASTQ -> BAM
#=====================================

# user parameter: define sample base name, without any extension
# for example base name for raw read file ERR00001_1.fastq is ERR00001
SAMPLE_BASE_NAME = "ERR00001"

# Software needed
BWA="/path/to/bwa.kit/bwa"
SAMTOOLS="/path/to/samtools"


FASTQ1="${SAMPLE_BASE_NAME}_1.fastq"
FASTQ2="{SAMPLE_BASE_NAME}_2.fastq"
REFERENCE="ref.fa"

# Note: no more than 2 threads per CPU core
$BWA mem -t 4 $REFERENCE $FASTQ1 $FASTQ2 | \
	$SAMTOOLS view -b > "${SAMPLE_BASE_NAME}.bam"

# Create head file
$SAMTOOLS view -H "${SAMPLE_BASE_NAME}.bam" > "${SAMPLE_BASE_NAME}.headfile.txt"



