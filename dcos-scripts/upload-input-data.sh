MASTER_NODE_IP=$1

LIVY_JARS="/Volumes/Playground/cloud/__CAREER/Master/LucrareDiploma/\
__ProiectLicenta/Incubator-Livy-Distribution/\
apache-livy-0.7.0-incubating-bin/jars"

LIVY_CLIENT_JAR="/Volumes/Playground/cloud/__CAREER/Master/LucrareDiploma/\
__ProiectLicenta/kyme-scheduling-service/target/universal/stage/lib/\
org.apache.livy.livy-scala-api_2.11-0.7.0-incubating.jar"

APP_JAR="/Volumes/Playground/cloud/__CAREER/Master/LucrareDiploma/\
__ProiectLicenta/kyme-scheduling-service/target/universal/stage/lib/\
com.mihainicola.spark-job_2.11-0.0.1-SNAPSHOT.jar"

FILE_PATH="/Volumes/Playground/cloud/__CAREER/Master/LucrareDiploma/\
__ProiectLicenta/BigDataBench/BigDataGeneratorSuite\
/Text_datagen/gen_data/wordcount-1G/lda_wiki1w_1"

#ssh-keygen -R $MASTER_NODE_IP
#scp $FILE_PATH root@$MASTER_NODE_IP:~
#scp $LIVY_CLIENT_JAR root@$MASTER_NODE_IP:~
#scp $APP_JAR root@$MASTER_NODE_IP:~
scp $LIVY_JARS/*.* root@$MASTER_NODE_IP:~/livy-jars