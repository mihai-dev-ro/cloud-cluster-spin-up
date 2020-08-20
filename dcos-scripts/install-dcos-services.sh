#!/bin/bash

# retrieve current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# config directory
BASE=${DIR##*/} 
DCOS_CONFIG_DIR=${DIR%$BASE}"dcos-services-config"

# install spark-shuffle services
dcos marathon app add "$DCOS_CONFIG_DIR/spark-shuffle-config.json"

# wait for shuffle service to be scheduled and installed
sleep 15s

# install hdfs
dcos package install --yes --options="$DCOS_CONFIG_DIR/hdfs-config.json" hdfs

# install spark
dcos package install --yes --options="$DCOS_CONFIG_DIR/spark-config.json" spark

# install spark-history
dcos package install --yes --options="$DCOS_CONFIG_DIR/spark-history-config.json" spark-history

# install dcos-monitoring
dcos package install --yes --options="$DCOS_CONFIG_DIR/dcos-monitoring-config.json" dcos-monitoring

# install marathon load balancer
dcos package install --yes --options="$DCOS_CONFIG_DIR/marathon-lb-config.json" marathon-lb

# install spark-monitoring
dcos marathon app add "$DCOS_CONFIG_DIR/spark-monitoring-config.json"

# install livy-service
dcos marathon app add "$DCOS_CONFIG_DIR/apache-livy-service-config.json"

# install kyme-service
dcos marathon app add "$DCOS_CONFIG_DIR/kyme-scheduling-service-config.json"
