#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Recalibrate read bases using BQSR
#=====================================
# 
# Note: AnalyzeCovariates depend on R and R packages.
# 		Before running this script, install R then 
#		install.packages(c("ggplot2","gplots","reshape","grid","tools","gsalib",dependencies=TRUE)

SAMPLE_BASE_NAME = "ERR00001"

# file names
BAM="${SAMPLE_BASE_NAME}.realigned.bam"
RECAL_BAM="${SAMPLE_BASE_NAME}.recal.bam"
BEFORE_RECAL_TABLE="${SAMPLE_BASE_NAME}.recal.table"
AFER_RECAL_TABLE="${SAMPLE_BASE_NAME}.recal.table.post"
RECAL_PDF="${SAMPLE_BASE_NAME}.recal.pdf"
REFERENCE="ref.fa"
KNOWN="known_sites.vcf"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="/path/to/samtools/"
GATK3="/path/to/GATK/GenomicAnalysisTK.jar"

#Generate covariate plots
echo "creating covariate plots"
java -jar $GATK3 \
	-T AnalyzeCovariates \
	-R $REFERENCE \
	-before $BEFORE_RECAL_TABLE \
	-after $AFER_RECAL_TABLE \
	-plots $RECAL_PDF

# Note: check covariate plots to make sure recalibrate actually worked!
echo "##### Note: check covariate plots to make sure recalibrate actually worked before actual recalibration! ######"

echo "recalibrating BAM"
java -jar $GATK3 \
	-T PrintReads \
	-R $REFERENCE \
	-I $BAM \
	-BQSR BEFORE_RECAL_TABLE \
	-o $RECAL_BAM

