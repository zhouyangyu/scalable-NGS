task MarkDuplicates {
  String SAMPLE_BASE_NAME
  
  String GS_PATH
  String CLUSTER_NAME
  
  String UNMARKED_BAM
  String MARKED_BAM
  String METRICS_FILE
  String KNOWN
  String FLAG_STATS
  String IDX_STATS
  String REFERENCE
  String REFERENCE_DICT

  String GATK4
  String PICARD
  String SAMTOOLS
  
  command {
        
        echo "creating sequence dictionary"
        ${PICARD} CreateSequenceDictionary \
        R=${REFERENCE}
        OUTPUT=${REFERENCE_DICT}

        echo "building reference index"
        ${SAMTOOLS} faidx ${REFERENCE}

        echo "marking duplicate reads"
        ${GATK4}/gatk-launch  MarkDuplicatesSpark \
        -I ${UNMARKED_BAM} \
        --knownSites ${KNOWN} \
        -M ${METRICS_FILE} \
        -O ${MARKED_BAM} \
        -- \
        --sparkRunner GCS \
        --cluster ${CLUSTER_NAME} \
        --region us-central1 \
        --num-executors 9 \
        --conf spark.executor.cores=2 \
        --conf spark.executor.memory=4g \
        --conf spark.yarn.executor.memoryOverhead=2000 \
        --conf spark.driver.memory=6g

        rm ${UNMARKED_BAM}

        #Get flagstat
        echo "getting flag stats"
        ${SAMTOOLS} flagstat ${MARKED_BAM} > ${FLAG_STATS}

        echo "getting index stats"
        ${SAMTOOLS} idxstats ${MARKED_BAM} > ${IDX_STATS}

        echo "indexing BAM"
        ${SAMTOOLS} index ${MARKED_BAM}
  

  }
  output {
  
    File METRICS_FILE = "${METRICS_FILE}"
    File MARKED_BAM = "${MARKED_BAM}"
    File FLAG_STATS = "${FLAG_STATS}"
    File IDX_STATS = "${FLAG_STATS}"
    File REFERENCE_DICT = "${REFERENCE_DICT}"
    
  }
}

workflow MarkDuplicatesWorkflow {
  call MarkDuplicates
}
