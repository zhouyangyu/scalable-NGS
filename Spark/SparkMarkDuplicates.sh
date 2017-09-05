#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Apache Spark 2.2
# Mark duplicate reads
#=====================================

SAMPLE_BASE_NAME = "ERR00001"

# cluster info
GS_PATH="gs://bucket_name"
CLUSTER_NAME="yarn-cluster"

# file names
UNMARKED_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.sorted.bam"
MARKED_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.dupMarked.bam"
METRICS_FILE="${GS_PATH}/${SAMPLE_BASE_NAME}.metrics.txt"
KNOWN="${GS_PATH}/known_sites.vcf"
FLAG_STATS="${GS_PATH}/${SAMPLE_BASE_NAME}.dupMarked.flagstats"
IDX_STATS="${GS_PATH}/${SAMPLE_BASE_NAME}.dupMarked.idxstats"
REFERENCE="${GS_PATH}/ref.fa"
REFERENCE_DICT="${GS_PATH}/${REFERENCE%.fa}.dict"

# software needed
GATK4="/path/to/GATK4/"
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="/path/to/samtools/"

echo "creating sequence dictionary"
$PICARD CreateSequenceDictionary \
	R=$REFERENCE
	OUTPUT=$REFERENCE_DICT

echo "building reference index"
$SAMTOOLS faidx $REFERENCE

echo "marking duplicate reads"
$GATK4/gatk-launch  MarkDuplicatesSpark \
	-I $UNMARKED_BAM \
	--knownSites $KNOWN \
	-M $METRICS_FILE \
	-O $MARKED_BAM \
	-- \
	--sparkRunner GCS \
	--cluster $CLUSTER_NAME \
	--region us-central1 \
	--num-executors 9 \
	--conf spark.executor.cores=2 \
	--conf spark.executor.memory=4g \
	--conf spark.yarn.executor.memoryOverhead=2000 \
	--conf spark.driver.memory=6g

rm $UNMARKED_BAM

#Get flagstat
echo "getting flag stats"
$SAMTOOLS flagstat $MARKED_BAM > FLAG_STATS

echo "getting index stats"
$SAMTOOLS idxstats $MARKED_BAM > IDX_STATS

echo "indexing BAM"
$SAMTOOLS index $MARKED_BAM