#!/bin/bash

BOOTSTRAP_NODE_IP=$1
MASTER_NODE_IP=$2

# retrieve current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# config directory
BASE=${DIR##*/}

ssh-keygen -R $BOOTSTRAP_NODE_IP
ssh root@$BOOTSTRAP_NODE_IP "cd /tmp/genconf && tar -czvf dcos-installer.tar.gz serve/"

wait
scp root@$BOOTSTRAP_NODE_IP:/tmp/genconf/dcos-installer.tar.gz ~

wait
ssh-keygen -R $MASTER_NODE_IP
scp ~/dcos-installer.tar.gz root@$MASTER_NODE_IP:~
