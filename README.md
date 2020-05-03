# Spin up a Scaleway cluster

Automate the provisioning of a cluster with the following configuration

- 1 __master__ machine (or 3 machines with zookeeper configured for leader election) with 2vCPUs, 2GB RAM, 20GB Disk space
- 3 __worker__ machines, each with 3vCPUs, 4GB RAM, 40GB Disk space

Total computing power is: 9 vCPUs, 12GB RAM
Total disk for HDFS: 120 GB

## Cluster Frameworks

Once the resource are provisioned, the following middleware/frameworks should be installed :

- [HDFS](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html) for the distributed storage of humonguous files
- [Spark](https://spark.apache.org) for distributed batch and stream processing
- [Kafka](https://kafka.apache.org) for distributed streaming 
- [Cassandra](https://cassandra.apache.org) for distributed NoSQL database

