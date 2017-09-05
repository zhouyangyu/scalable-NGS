#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Sort BAM file, check RG info
#=====================================

SAMPLE_BASE_NAME = "ERR00001"

# file names
UNSORTED_BAM="${SAMPLE_BASE_NAME}.bam"
SORTED_BAM="${SAMPLE_BASE_NAME}.sorted.bam"
HEAD_FILE="${SAMPLE_BASE_NAME}.headfile.txt"

# software needed
PICARD="/path/to/picard/picard.jar"
SAMTOOLS="samtools"

#check if BAM file satisfies GATK requirement
$SAMTOOLS view -H $UNSORTED_BAM > grep '^@SQ' > temp.txt
T="sort -c -t ':' -nk2 temp.txt"
if [ "$T" ]; then
	echo "BAM is sorted."
else
	echo "BAM is not sorted. Sorting BAM......"
	java -Xmx4G -jar $PICARD SortSam \
		INPUT=$UNSORTED_BAM \
		OUTPUT=$SORTED_BAM \
		SORT_ORDER=coordinate
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