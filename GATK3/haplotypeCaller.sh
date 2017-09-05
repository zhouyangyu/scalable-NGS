#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Calling Variants using HaplotypeCaller
#=====================================
#
# Note: Adjust the parameter of HaplotypeCaller to fit the research needs.

# file names
BAM="${SAMPLE_BASE_NAME}.recal.bam"
G_VCF="${SAMPLE_BASE_NAME}.indels.g.vcf"
REFERENCE="ref.fa"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="/path/to/samtools/"
GATK3="/path/to/GATK/GenomicAnalysisTK.jar"

#HaplotypeCaller
java -jar $GATK3 \
     -R $REFERENCE \
     -T HaplotypeCaller \
     -I $BAM \
     --emitRefConfidence GVCF \
     -o $GVCF

