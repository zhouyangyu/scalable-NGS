#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Align raw reads to reference genome, FASTQ -> BAM
#=====================================

# user parameter: define sample base name, without any extension
# for example base name for raw read file ERR00001_1.fastq is ERR00001

SAMPLE_BASE_NAME = "ERR00001"

# file names
FASTQ1="${SAMPLE_BASE_NAME}_1.fastq"
FASTQ2="${SAMPLE_BASE_NAME}_2.fastq"
ALIGNED_BAM="${SAMPLE_BASE_NAME}.bam"
HEAD_FILE="${SAMPLE_BASE_NAME}.headfile.txt"
REFERENCE="ref.fa"

# Software needed
BWA="/path/to/bwa.kit/bwa"
SAMTOOLS="/path/to/samtools"

# Note: no more than 2 threads per CPU core
$BWA mem -t 4 $REFERENCE $FASTQ1 $FASTQ2 | \
	$SAMTOOLS view -b > ALIGNED_BAM

# Create head file
$SAMTOOLS view -H $ALIGNED_BAM > HEAD_FILE



