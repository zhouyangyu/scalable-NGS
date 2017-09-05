#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Recalibrate read bases using BQSR
#=====================================

SAMPLE_BASE_NAME = "ERR00001"

# file names
UNRECAL_BAM="${SAMPLE_BASE_NAME}.realigned.bam"
RECAL_TABLE="${SAMPLE_BASE_NAME}.recal.table"
POST_RECAL_TABLE="${SAMPLE_BASE_NAME}.recal.table.post"
REFERENCE="ref.fa"
KNOWN="known_sites.vcf"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="/path/to/samtools/"
GATK3="/path/to/GATK/GenomicAnalysisTK.jar"

#Step 2 - Base recalibration
echo "recalibrating base part 1......"
java -jar $GATK3 \
	-T BaseRecalibrator \
	-R $REFERENCE \
	-I $UNRECAL_BAM \
	-knownSites $KNOWN \
	-o RECAL_TABLE

echo "recalibrating base part 2......"
java -jar $GATK3 \
	-T BaseRecalibrator \
	-R $REFERENCE \
	-I $UNRECAL_BAM \
	-knownSites $KNOWN \
	-BQSR $RECAL_TABLE \
	-o $POST_RECAL_TABLE