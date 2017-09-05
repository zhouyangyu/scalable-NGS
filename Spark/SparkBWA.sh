#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Apache Spark
# Align raw reads to reference genome, FASTQ -> BAM
#=====================================

# user parameter: define sample base name, without any extension
# for example base name for raw read file ERR00001_1.fastq is ERR00001
#
# Note: Master IP must be external IP, YARN port is 8088 on gcloud
# Note: All path must be absolute path
# Note: index files (dict,fai,ann...) must be present at the same directory at all worker nodes.

SAMPLE_BASE_NAME = "ERR00001"

# cluster info
GS_PATH="gs://bucket_name"
MASTER_IP="spark://12.32.43.31:8088"

# file names
FASTQ1="${GS_PATH}/${SAMPLE_BASE_NAME}_1.fastq"
FASTQ2="${GS_PATH}/${SAMPLE_BASE_NAME}_2.fastq"
ALIGNED_BAM="${GS_PATH}/${SAMPLE_BASE_NAME}.bam"
HEAD_FILE="${GS_PATH}/${SAMPLE_BASE_NAME}.headfile.txt"
REFERENCE="${GS_PATH}/ref.fa"

# Software needed
SPARK_BWA="absolute/path/to/SparkBWA/target/SparkBWA-0.2.jar"
SAMTOOLS="/path/to/samtools"

spark-submit \
	--class com.github.sparkbwa.SparkBWA \
	--master $MASTER_IP \
	--deploy-mode cluster \
	--num-executors 5 \
	--conf spark.executor.cores=4 \
	--conf spark.executor.memory=11g \
	--conf spark.yarn.executor.memoryOverhead=2000 \
	--conf spark.driver.memory=5g \
	--verbose \
	$SPARK_BWA \
	-m \
	-r \
	-p \
	-w "-t 4" \
	--index "${REFERENCE%.fa}" \
	$FASTQ1 \
	$FASTQ2 \
	$ALIGNED_BAM

# Create head file
$SAMTOOLS view -H $ALIGNED_BAM > $HEAD_FILE
