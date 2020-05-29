#!/bin/sh

# directory of current bash script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# config directory
BASE=${DIR##*/} 
SPARK_JOB_PROPS=${DIR%$BASE}"spark-job-properties"

dcos spark run --submit-args="\
--properties-file=$SPARK_JOB_PROPS/job.props \
--class org.apache.spark.examples.SparkPi \
https://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.4.0.jar 1000"

