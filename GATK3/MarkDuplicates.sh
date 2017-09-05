#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Mark duplicate reads
#=====================================

SAMPLE_BASE_NAME = "ERR00001"

# file names
UNMARKED_BAM="${SAMPLE_BASE_NAME}.sorted.bam"
MARKED_BAM="${SAMPLE_BASE_NAME}.dupMarked.bam"
METRICS_FILE="${SAMPLE_BASE_NAME}.metrics.txt"
FLAG_STATS="${SAMPLE_BASE_NAME}.dupMarked.flagstats"
IDX_STATS="${SAMPLE_BASE_NAME}.dupMarked.idxstats"
REFERENCE="ref.fa"
REFERENCE_DICT="${REFERENCE%.fa}.dict"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="/path/to/samtools/"

echo "creating sequence dictionary"
$PICARD CreateSequenceDictionary \
	R=$REFERENCE
	OUTPUT=$REFERENCE_DICT

echo "building reference index"
$SAMTOOLS faidx $REFERENCE

#Mark duplicates
echo "marking duplicates"
java -Xmx4G -jar $PICARD MarkDuplicates \
	INPUT=$UNMARKED_BAM \
    OUTPUT=$MARKED_BAM \
    METRICS_FILE=$METRICS_FILE \
    CREATE_INDEX=TRUE \
    REMOVE_DUPLICATES=false

rm $UNMARKED_BAM

#Get flagstat
echo "getting flag stats"
$SAMTOOLS flagstat $MARKED_BAM > FLAG_STATS

echo "getting index stats"
$SAMTOOLS idxstats $MARKED_BAM > IDX_STATS

echo "indexing BAM"
$SAMTOOLS index $MARKED_BAM