#!/bin/bash
#built for Debian GNU Linux 9
#initial cluster, install essential software
#user basic-single-node snapshot (which is just an empty snapshot of disk of a worker node), it has all the tools such as java
#runs about 7 mins.

#install Maven
cd /home/jozhou17
wget "http://apache.cs.utah.edu/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz"
tar xzvf apache-maven-3.5.0-bin.tar.gz
export PATH=$PATH:/home/jozhou17/apache-maven-3.5.0/bin
rm apache-maven-3.5.0-bin.tar.gz

#install SparkBWA
cd /home/jozhou17
git clone https://github.com/citiususc/SparkBWA.git
cd /home/jozhou17/SparkBWA
/home/jozhou17/apache-maven-3.5.0/bin/mvn package 2>&1 | tee /home/jozhou17/err.out

#install GATK4
cd /home/jozhou17
git clone https://github.com/broadinstitute/gatk.git
cd /home/jozhou17/gatk
./gradlew bundle 2>&1 | tee /home/jozhou17/err.out


echo "end" > /home/jozhou17/err.out

#ROLE=$(/usr/share/google/get_metadata_value attributes/dataproc-rote)
#if [[ "${ROLE}" == 'Master' ]]; then

	