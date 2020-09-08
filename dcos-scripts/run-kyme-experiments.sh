#!/bin/bash

# argument file name: hdfs:///data/10GB/lda_wiki1w
BENCHMARK_FILE_ROOT=$1

# argument nb of files
NB_FILES=$2

# argument for shared contextManager
SHARED_CONTEXT_INDEX=$3

printf "\n\nStop Shared Context"
curl --location \
--request GET "http://51.15.117.67:7900/jobSetManager-stop/jobSetManager-$SHARED_CONTEXT_INDEX"

sleep 1

printf "\n\nJob 1:\n"
# 1. curl POST submit-job, query: distributed
curl --location --request POST "http://51.15.117.67:7900/job-submit" \
--header "Content-Type: application/json" \
--data-raw "{
    \"inputRootFileLocation\": \"$BENCHMARK_FILE_ROOT\",
    \"nbFiles\": $NB_FILES,
    \"searchKey\": \"distributed\",
    \"resultsLocation\": \"hdfs:///spark-job/grep/results/output-01-01.txt\",
    \"appJars\": \"hdfs://hdfs/spark-job/grep/jars/kyme-sparkjobfull-assembly-0.0.1-SNAPSHOT.jar\"
}" | jq .

printf "\n\nJob 2:\n"
# 2. curl POST submit-job, query: computing
curl --location --request POST "http://51.15.117.67:7900/job-submit" \
--header "Content-Type: application/json" \
--data-raw "{
    \"inputRootFileLocation\": \"$BENCHMARK_FILE_ROOT\",
    \"nbFiles\": $NB_FILES,
    \"searchKey\": \"computation\",
    \"resultsLocation\": \"hdfs:///spark-job/grep/results/output-01-01.txt\",
    \"appJars\": \"hdfs://hdfs/spark-job/grep/jars/kyme-sparkjobfull-assembly-0.0.1-SNAPSHOT.jar\"
}" | jq .

printf "\n\nJob 3:\n"
# 3. curl POST submit-job, query: algorithms
curl --location --request POST "http://51.15.117.67:7900/job-submit" \
--header "Content-Type: application/json" \
--data-raw "{
    \"inputRootFileLocation\": \"$BENCHMARK_FILE_ROOT\",
    \"nbFiles\": $NB_FILES,
    \"searchKey\": \"algorithm\",
    \"resultsLocation\": \"hdfs:///spark-job/grep/results/output-01-01.txt\",
    \"appJars\": \"hdfs://hdfs/spark-job/grep/jars/kyme-sparkjobfull-assembly-0.0.1-SNAPSHOT.jar\"
}" | jq .

printf "\n\nJob 4:\n"
# 4. curl POST submit-job, query: category
curl --location --request POST "http://51.15.117.67:7900/job-submit" \
--header "Content-Type: application/json" \
--data-raw "{
    \"inputRootFileLocation\": \"$BENCHMARK_FILE_ROOT\",
    \"nbFiles\": $NB_FILES,
    \"searchKey\": \"typed\",
    \"resultsLocation\": \"hdfs:///spark-job/grep/results/output-01-01.txt\",
    \"appJars\": \"hdfs://hdfs/spark-job/grep/jars/kyme-sparkjobfull-assembly-0.0.1-SNAPSHOT.jar\"
}" | jq .

printf "\n\nJob 5:\n"
# 5. curl POST submit-job, query: category
curl --location --request POST "http://51.15.117.67:7900/job-submit" \
--header "Content-Type: application/json" \
--data-raw "{
    \"inputRootFileLocation\": \"$BENCHMARK_FILE_ROOT\",
    \"nbFiles\": $NB_FILES,
    \"searchKey\": \"systems\",
    \"resultsLocation\": \"hdfs:///spark-job/grep/results/output-01-01.txt\",
    \"appJars\": \"hdfs://hdfs/spark-job/grep/jars/kyme-sparkjobfull-assembly-0.0.1-SNAPSHOT.jar\"
}" | jq .

