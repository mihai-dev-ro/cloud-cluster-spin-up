#!/bin/bash

# ask for confirmation that the script is run on a DCOS node
read -p "Are you on a DCOS node? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# retrieve the hadoop archive
curl -LO https://archive.apache.org/dist/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
# verify package integrity
curl -O https://downloads.apache.org/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz.asc
curl -O https://downloads.apache.org/hadoop/common/KEYS
gpg --import KEYS
gpg --verify hadoop-3.2.1.tar.gz.asc

# pause the script to accept or not the continuation
read -p "Continue? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# extract it and put it into /opt directory
tar -xzvf hadoop-3.2.1.tar.gz
mv hadoop-3.2.1 /opt/hadoop

# import the hdfs cluster properties
cd /opt/hadoop/etc/hadoop
mv core-site.xml core-site.xml.bak-$(date +%Y%m%d-%H%M%S)
mv hdfs-site.xml hdfs-site.xml.bak-$(date +%Y%m%d-%H%M%S)
curl -O http://api.hdfs.marathon.l4lb.thisdcos.directory/v1/endpoints/core-site.xml
curl -O http://api.hdfs.marathon.l4lb.thisdcos.directory/v1/endpoints/hdfs-site.xml

# set the environment variable HADOOP_HOME
echo "HADOOP_HOME=/opt/hadoop" >> ~/.bash_profile
echo "export HADOOP_HOME" >> ~/.bash_profile

# install java
yum install -y java-1.8.0-openjdk
# set the path variables

# set environment variable JAVA_HOME
echo "JAVA_HOME=/usr/lib/jvm/jre" >> ~/.bash_profile
echo "export JAVA_HOME" >> ~/.bash_profile

# add hdfs binary to PATH 
echo "PATH=$PATH:/opt/hadoop/bin" >> ~/.bash_profile
sed -i "/export PATH/d" ~/.bash_profile
echo "export PATH" >> ~/.bash_profile

# read and execute the bash_profile
source ~/.bash_profile

# add /history directory in hdfs 
hdfs dfs -mkdir /history
hdfs dfs -chmod 666 /history