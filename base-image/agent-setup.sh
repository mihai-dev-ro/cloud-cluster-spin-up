# author: https://github.com/geekbass/dcos-agent-centos7-ami/blob/master/agent-setup.sh

#!/bin/bash
set -e

# Install epel-release for later
sudo yum install -y epel-release wget curl

# Setup Python
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
sudo python get-pip.py
sudo rm -rf get-pip.py
sudo pip install virtualenv
sudo yum install -y libselinux-python

# Install jq becasue it is awesome! Yay!
sudo yum install jq -y


# Install Ansible for Ansible Provisioner
sudo yum install -y ansible 

#reboot
#sudo reboot