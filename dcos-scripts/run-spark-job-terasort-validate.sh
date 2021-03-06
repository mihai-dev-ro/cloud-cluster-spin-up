#!/bin/sh

# directory of current bash script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# config directory
BASE=${DIR##*/} 
SPARK_JOB_PROPS=${DIR%$BASE}"spark-job-properties"

dcos spark run --submit-args="\
--properties-file=$SPARK_JOB_PROPS/job.props \
--class com.github.ehiggs.spark.terasort.TeraValidate \
https://github.com/mihai-dev-ro/spark-terasort/raw/master/spark-terasort-1.1-SNAPSHOT.jar \
hdfs://hdfs/spark-job/terasort/data/output"

