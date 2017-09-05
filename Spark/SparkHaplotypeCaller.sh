#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Apache Spark
# Variant Discovery using HaplotypeCaller
#=====================================
#
# Note: User must mannually configure cluster info such as spark.executor.cores.
#
# Note: Reference must be in 2bit format. Use faToTwoBit from UCSC to convert.
# Note: Reference files (2bit, idx, dict, etc. must be local to all nodes, including workers)
# Note: Using this script will, by default, automatically apply the following read filters to the data before BaseRecalibratorSpark. To disable read filters before analysis, add --disableReadFilter filter_name or --disableToolDefaultReadFilters TRUE
#			PassesVendorQualityCheckReadFilter
#			MappedReadFilter
#			PrimaryAlignmentReadFilter
#			WellformedReadFilter
#			MappingQualityReadFilter
#			NotDuplicateReadFilter
#			MappingQualityAvailableReadFilter
#			GoodCigarReadFilter
#			NonZeroReferenceLengthAlignmentReadFilter

SAMPLE_BASE_NAME = "ERR00001"

# cluster info
GS_PATH="gs://bucket_name"
CLUSTER_NAME="yarn-cluster"

# file names
RECAL_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.recal.bam"
G_VCF="${GS_PATH}/${SAMPLE_BASE_NAME}.indels.g.vcf"
REFERENCE="ref.2bit"

# software needed
GATK4="/path/to/GATK4/"

$GATK4/gatk-launch HaplotypeCallerSpark \
	-I $RECAL_BAM
	-O $G_VCF \
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


