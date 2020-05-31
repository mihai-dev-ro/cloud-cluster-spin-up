#!/bin/bash

# retrieve current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# config directory
BASE=${DIR##*/} 
DCOS_CONFIG_DIR=${DIR%$BASE}"dcos-services-config"

# install spark-shuffle services
dcos marathon app add < "$DCOS_CONFIG_DIR/spark-shuffle-config.json"

# install hdfs
dcos package install --options="$DCOS_CONFIG_DIR/hdfs-config.json" hdfs

# install spark
dcos package install --options="$DCOS_CONFIG_DIR/spark-config.json" spark

# install spark-history
dcos package install --options="$DCOS_CONFIG_DIR/spark-history-config.json" spark-history

# install dcos-monitoring
dcos package install --options="$DCOS_CONFIG_DIR/dcos-monitoring-config.json" dcos-monitoring

