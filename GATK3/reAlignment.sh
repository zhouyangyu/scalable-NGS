#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Realign reads around known Indels
#=====================================

SAMPLE_BASE_NAME = "ERR00001"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="/path/to/samtools/"
GATK3="/path/to/GATK/GenomicAnalysisTK.jar"

UNREALIGNED_BAM="${SAMPLE_BASE_NAME}.dupMarked.bam"
REALIGNED_BAM="${SAMPLE_BASE_NAME}.realigned.bam"
TARGET_INTERVALS="${SAMPLE_BASE_NAME}.targetIntervals"
REFERENCE="ref.fa"
KNOWN="known_sites.vcf"

#Step 1 - local realignment around indels
echo "Running GATK3 RealignerTargetCreator"
java -jar $GATK3 \
	-T RealignerTargetCreator \
	-R $REFERENCE \
	-I $UNREALIGNED_BAM \
	--known $KNOWN \
	-o $TARGET_INTERVALS

echo "Runnig local realignment around indels"
java -jar $GATK3 \
	-T IndelRealigner \
	-R $REFERENCE \
	-I $UNREALIGNED_BAM \
	-targetIntervals $TARGET_INTERVALS \
	-o $REALIGNED_BAM
rm $UNREALIGNED_BAM 

echo "Indexing realigned BAM"
$SAMTOOLS index $REALIGNED_BAM