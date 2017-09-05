#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Apache Spark
# BAM -> GVCF
#=====================================
#
# Note: This pipeline takes significant disk space and memory space, as well as time. Master and worker nodes need to be at least n1-standard-4. Disk space needs to be at least 50G per sample (low coverage). Have not been tested on high coverage samples.
#
# Note: User must mannually configure cluster info such as spark.executor.cores.
# 
# Note: Reference must be in 2bit format. Use faToTwoBit from UCSC to convert.
# Note: Read filters will be applied automatically by default. To disable selected read filters, add --disableReadFilter fileter_name. To disable all default read filters, add --disableToolDefaultReadFilters TRUE


SAMPLE_BASE_NAME = "ERR00001"

# cluster info
GS_PATH="gs://bucket_name"
CLUSTER_NAME="yarn-cluster"

# file names
SORTED_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.sorted.bam"
G_VCF="${GS_PATH}/${SAMPLE_BASE_NAME}.indels.g.vcf"
REFERENCE="ref.2bit"
KNOWN="${GS_PATH}/known_sites.vcf"

# software needed
GATK4="/path/to/GATK4/"

$GATK4/gatk-launch ReadsPipelineSpark \
	-I $SORTED_BAM
	--knownSites $KNOWN
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
