#!/bin/bash

# Author: Joe Zhou	jozhou17@gmail.com

#=====================================
# Create Google Cloud Dataproc cluster
#=====================================
# 
# Note: need to install gcloud SDK first.

# Cluster setting
REGION="us-central1"
CLUSTER_NAME="yarn-cluster"
MASTER_MACHINE_TYPE="n1-standard-2"
MASTER_DISK_SIZE="100"
NUM_WORKERS="2" # min 2
WORKER_MACHINE_TYPE="n1-standard-2"
WORKER_DISK_SIZE="50"
PROJECT_NAME="my_project"
INIT_SCRIPT="gs://bucket_name/cluster_init.sh"

gcloud dataproc \
	--region $REGION \
	clusters create $CLUSTER_NAME \
	--subnet default \
	--zone "" \
	--master-machine-type $MASTER_MACHINE_TYPE \
	--master-boot-disk-size $MASTER_DISK_SIZE \
	--num-workers $NUM_WORKERS \
	--worker-machine-type $WORKER_MACHINE_TYPE \
	--worker-boot-disk-size $WORKER_DISK_SIZE \
	--scopes 'https://www.googleapis.com/auth/cloud-platform' \
	--project $PROJECT_NAME	 \
	--initialization-actions $INIT_SCRIPT \
	--initialization-action-timeout 20m