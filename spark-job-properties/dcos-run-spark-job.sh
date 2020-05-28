#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo $DIR/job.props

dcos spark run --submit-args="\
--properties-file=$DIR/job.props \
--class org.apache.spark.examples.SparkPi \
https://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.4.0.jar 10000000"

