#!/bin/bash

# uninstall spark-shuffle services
dcos marathon app remove spark-shuffle-service

# uninstall hdfs
dcos package uninstall --yes hdfs

# uninstall spark
dcos package uninstall --yes spark

# uninstall spark-history
dcos package uninstall --yes spark-history

# uninstall dcos-monitoring
dcos package uninstall --yes dcos-monitoring

# uninstall load balancer
dcos package uninstall --yes marathon-lb

# remove spark monitoring
dcos marathon app remove spark-monitoring-service
