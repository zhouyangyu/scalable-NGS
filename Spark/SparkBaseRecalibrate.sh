#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Apache Spark
# Recalibrate read bases using BQSR
#=====================================
#
# Note: User must mannually configure cluster info such as spark.executor.cores.
#
# Note: Reference must be in 2bit format. Use faToTwoBit from UCSC to convert.
# Note: Reference files (2bit, idx, dict, etc. must be local to all nodes, including workers)
# Note: Using this script will, by default, automatically apply the following read filters to the data before BaseRecalibratorSpark. To disable read filters before analysis, add --disableReadFilter filter_name or --disableToolDefaultReadFilters TRUE
#			PassesVendorQualityCheckReadFilter
#			MappingQualityNotZeroReadFilter
#			MappedReadFilter
#			PrimaryAlignmentReadFilter
#			WellformedReadFilter
#			NotDuplicateReadFilter
#			MappingQualityAvailableReadFilter

SAMPLE_BASE_NAME = "ERR00001"

# cluster info
GS_PATH="gs://bucket_name"
CLUSTER_NAME="yarn-cluster"

# file names
UNRECAL_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.realigned.bam"
RECAL_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.recal.bam"
RECAL_TABLE="${GS_PATH}/${SAMPLE_BASE_NAME}.recal.table"
POST_RECAL_TABLE="${GS_PATH}/${SAMPLE_BASE_NAME}.recal.table.post"
REFERENCE="ref.2bit"
KNOWN="${GS_PATH}/known_sites.vcf"

# software needed
GATK4="/path/to/GATK4/"

$GATK4/gatk-launch  BaseRecalibratorSpark \
	-I $UNRECAL_BAM \
	--knownSites $KNOWN \
	-O $RECAL_TABLE \
	-R $REFERENCE \
	-- \
	--sparkRunner GCS \
	--cluster $CLUSTER_NAME \
	--region us-central1 \
	--num-executors 9 \
	--conf spark.executor.cores=2 \
	--conf spark.executor.memory=4g \
	--conf spark.yarn.executor.memoryOverhead=2000 \
	--conf spark.driver.memory=6g

# Note: WellformedReadFilter is automatically applied to ApplyBQSRSpark. To disable, add --disableToolDefaultFilters TRUE
$GATK4/gatk-launch  ApplyBQSRSpark \
	-I $UNRECAL_BAM \
	-bqsr $RECAL_TABLE \
	-R $REFERENCE \
	-O $RECAL_BAM \
	-- \
	--sparkRunner GCS \
	--cluster $CLUSTER_NAME \
	--region us-central1 \
	--num-executors 9 \
	--conf spark.executor.cores=2 \
	--conf spark.executor.memory=4g \
	--conf spark.yarn.executor.memoryOverhead=2000 \
	--conf spark.driver.memory=6g
