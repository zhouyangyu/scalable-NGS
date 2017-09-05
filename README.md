# Scalable NGS pipeline on Dataproc


This porject aimed to solve the problem of too much data in NGS pipelines, especially WGS, WES. In summary, this project implements analysis tools that are built on Apache Spark to align, process, and analyze large NGS data. It inherit the benefits of Spark, such as scalable, elastic, and highly-available.

  - Implemented in Google Cloud Dataproc environment
  - Uses SparkBWA, GATK 4 beta, Cromwell Execution Engine
  - Speeds up end-to-end data processing by at least 3x (using a cluster of 5 worker nodes)


It also:
  - Imports and stores files on Google storage
  - Uses all common analysis tools with excellent documentation and support communities.
  - *needs your improvements!*


### Installation
You need:
  - a Google Cloud account (it comes with $300 credit) or AWS
  - set up a Hadoop cluster using YARN, with Apache Spark 2.2 installed 
  - initate all cluster nodes with cluster_init.sh (installs Maven, SparkBWA, GATK)

### Todos

 - Implement workflow in WDL and Cromwell
 - ADAM
 - Better documentation
