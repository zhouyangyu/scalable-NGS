#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Apache Spark
# Sort BAM file, check RG info
#=====================================

SAMPLE_BASE_NAME = "ERR00001"

# cluster info
GS_PATH="gs://bucket_name"
CLUSTER_NAME="yarn-cluster"

# file names
UNSORTED_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.bam"
SORTED_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.sorted.bam"
HEAD_FILE="${GS_PATH}/${SAMPLE_BASE_NAME}.headfile.txt"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="samtools"
GATK4="/path/to/GATK4/"

#check if BAM file satisfies GATK requirement
$SAMTOOLS view -H $UNSORTED_BAM > grep '^@SQ' > temp.txt
T="sort -c -t ':' -nk2 temp.txt"
if [ "$T" ]; then
	echo "BAM is sorted."
else
	echo "BAM is not sorted. Sorting BAM......"
	
	$GATK4/gatk-launch  SortReadFileSpark \
	-I $UNSORTED_BAM \
	-O $SORTED_BAM \
	-- \
	--sparkRunner GCS \
	--cluster $CLUSTER_NAME \
	--region us-central1 \
	--num-executors 9 \
	--conf spark.executor.cores=2 \
	--conf spark.executor.memory=4g \
	--conf spark.yarn.executor.memoryOverhead=2000 \
	--conf spark.driver.memory=6g

fi
rm temp.txt
rm $UNSORTED_BAM #remove unsorted BAM

#check if the file contains Read Group information
if [grep -q '^@RG' $HEAD_FILE]; then
	echo "File contains RG information"
	rm $HEAD_FILE
else
	echo "ERROR: File does not contain RG information."
	exit
fi